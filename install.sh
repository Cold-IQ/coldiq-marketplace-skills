#!/usr/bin/env bash
#
# ColdIQ — one-command installer & updater for AI coding agents.
#
# Installs the ColdIQ MCP server (search / enrich / verify / signals tools) and,
# where the agent supports them, the 18 GTM skills — into whichever agents you
# have: Claude Code, Cursor, Codex, Windsurf, Cline.
#
# Usage (install or update — safe to re-run):
#   curl -fsSL https://raw.githubusercontent.com/Cold-IQ/coldiq-marketplace-skills/main/install.sh | bash
#
# Provide your key non-interactively (skips the prompt):
#   curl -fsSL .../install.sh | COLDIQ_API_KEY=ck_live_xxx bash
#   curl -fsSL .../install.sh | bash -s -- ck_live_xxx

set -uo pipefail

REPO="Cold-IQ/coldiq-marketplace-skills"
MARKETPLACE="coldiq"
PLUGIN="coldiq"
PLUGIN_REF="${PLUGIN}@${MARKETPLACE}"
MCP_CMD="npx"
MCP_ARGS_JSON='["-y","@coldiq/mcp@latest"]'

# --- pretty output ------------------------------------------------------------
if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  BOLD="$(tput bold)"; DIM="$(tput dim)"; RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"; YELLOW="$(tput setaf 3)"; BLUE="$(tput setaf 4)"; RESET="$(tput sgr0)"
else
  BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; RESET=""
fi
info()  { printf '%s\n' "${BLUE}›${RESET} $*"; }
ok()    { printf '%s\n' "${GREEN}✔${RESET} $*"; }
warn()  { printf '%s\n' "${YELLOW}⚠${RESET} $*"; }
err()   { printf '%s\n' "${RED}✗${RESET} $*" >&2; }
step()  { printf '\n%s\n' "${BOLD}$*${RESET}"; }

CONFIGURED=""   # human-readable list for the summary
KEY=""

printf '\n%s\n' "${BOLD}ColdIQ — installer for AI coding agents${RESET}"

# --- JSON tool (python3 preferred, node fallback) -----------------------------
JSON_TOOL=""
if command -v python3 >/dev/null 2>&1; then JSON_TOOL="python3"
elif command -v node >/dev/null 2>&1; then JSON_TOOL="node"; fi

# Merge the coldiq MCP server (with the API key) into a {mcpServers:{...}} JSON
# config at $1, preserving everything else. Writes atomically and chmod 600
# (the file holds a credential). Returns: 0 wrote · 1 no JSON tool · 3 the
# existing file isn't valid JSON object — left UNTOUCHED so we never clobber a
# user's other MCP servers; the caller warns them to add it manually.
write_json_mcp() {
  cfg="$1"
  case "$JSON_TOOL" in
    python3)
      python3 - "$cfg" "$KEY" "$MCP_CMD" "$MCP_ARGS_JSON" <<'PY'
import json, sys, pathlib, os
cfg, key, cmd, args = sys.argv[1], sys.argv[2], sys.argv[3], json.loads(sys.argv[4])
p = pathlib.Path(cfg)
d = {}
if p.exists():
    raw = p.read_text()
    if raw.strip():
        try:
            d = json.loads(raw)
        except Exception:
            sys.exit(3)            # don't overwrite an unparseable config
        if not isinstance(d, dict):
            sys.exit(3)
servers = d.get("mcpServers")
if not isinstance(servers, dict): servers = {}
servers["coldiq"] = {"command": cmd, "args": args, "env": {"COLDIQ_API_KEY": key}}
d["mcpServers"] = servers
p.parent.mkdir(parents=True, exist_ok=True)
tmp = str(p) + ".coldiq.tmp"
with open(tmp, "w") as f:
    f.write(json.dumps(d, indent=2) + "\n")
os.replace(tmp, str(p))            # atomic
try: os.chmod(str(p), 0o600)
except OSError: pass
PY
      ;;
    node)
      node -e '
const fs=require("fs"),path=require("path");
const [cfg,key,cmd,args]=[process.argv[1],process.argv[2],process.argv[3],JSON.parse(process.argv[4])];
let d={};
if(fs.existsSync(cfg)){
  const raw=fs.readFileSync(cfg,"utf8");
  if(raw.trim()){
    try{ d=JSON.parse(raw); }catch(e){ process.exit(3); }   // dont overwrite unparseable
    if(typeof d!=="object"||d===null||Array.isArray(d)) process.exit(3);
  }
}
if(typeof d.mcpServers!=="object"||d.mcpServers===null)d.mcpServers={};
d.mcpServers.coldiq={command:cmd,args:args,env:{COLDIQ_API_KEY:key}};
fs.mkdirSync(path.dirname(cfg),{recursive:true});
const tmp=cfg+".coldiq.tmp";
fs.writeFileSync(tmp,JSON.stringify(d,null,2)+"\n");
fs.renameSync(tmp,cfg);                                      // atomic
try{ fs.chmodSync(cfg,0o600); }catch(e){}
' "$cfg" "$KEY" "$MCP_CMD" "$MCP_ARGS_JSON"
      ;;
    *) return 1 ;;
  esac
}

# Write the MCP config for an agent and report the outcome (dedups the call sites).
configure_mcp_json() {
  label="$1"; path="$2"
  write_json_mcp "$path"; rc=$?
  if [ "$rc" -eq 0 ]; then
    ok "MCP server written to ${path/#$HOME/\~}"
  elif [ "$rc" -eq 3 ]; then
    warn "${path/#$HOME/\~} exists but isn't valid JSON — left it untouched."
    printf '%s\n' "  Add the coldiq server to its \"mcpServers\" block manually (see README)."
  else
    warn "No python3 or node found — couldn't write ${label} MCP config."
  fi
}

# Read the API key from env / first arg / interactive prompt. Stored in $KEY.
get_key() {
  [ -n "$KEY" ] && return 0
  KEY="${COLDIQ_API_KEY:-}"
  [ "$#" -ge 1 ] && [ -n "${1:-}" ] && KEY="$1"
  if [ -z "$KEY" ] && [ -r /dev/tty ]; then
    printf '\n%s\n' "${BOLD}Enter your ColdIQ API key${RESET} ${DIM}(create one at https://coldiq.com/marketplace → API keys)${RESET}"
    printf 'API key: '
    trap 'stty echo </dev/tty 2>/dev/null || true' EXIT INT TERM
    stty -echo </dev/tty 2>/dev/null || true
    IFS= read -r KEY </dev/tty || true
    stty echo </dev/tty 2>/dev/null || true
    trap - EXIT INT TERM
    printf '\n'
  fi
  [ -n "$KEY" ]
}

# Install skills into a skill-native agent via vercel-labs/skills.
install_skills() {
  agent="$1"
  command -v npx >/dev/null 2>&1 || { warn "npx not found — skipping ${agent} skills (install Node.js)."; return 1; }
  npx -y skills@latest add "$REPO" --agent "$agent" --global --yes >/dev/null 2>&1
}

# Upsert the canonical ColdIQ block into an AGENTS.md (Codex's only guidance
# channel — it has no skills loader). Marker-delimited so re-runs replace just
# our block and never clobber the user's own AGENTS.md content.
upsert_agents_md() {
  target="$1"
  command -v curl >/dev/null 2>&1 || return 1
  [ -n "$JSON_TOOL" ] || return 1
  tmp="$(mktemp "${TMPDIR:-/tmp}/coldiq-agents.XXXXXX")" || return 1
  if ! curl -fsSL "https://raw.githubusercontent.com/${REPO}/main/AGENTS.md" -o "$tmp" 2>/dev/null || [ ! -s "$tmp" ]; then
    rm -f "$tmp"; return 1
  fi
  case "$JSON_TOOL" in
    python3)
      python3 - "$tmp" "$target" <<'PY'
import sys, re, pathlib
block = open(sys.argv[1]).read().strip()
t = pathlib.Path(sys.argv[2])
existing = t.read_text() if t.exists() else ""
pat = re.compile(r"<!-- BEGIN COLDIQ -->.*?<!-- END COLDIQ -->", re.S)
if pat.search(existing):
    new = pat.sub(lambda _: block, existing)
elif existing.strip():
    new = existing.rstrip() + "\n\n" + block + "\n"
else:
    new = block + "\n"
t.parent.mkdir(parents=True, exist_ok=True)
t.write_text(new)
PY
      ;;
    node)
      node -e '
const fs=require("fs"),path=require("path");
const block=fs.readFileSync(process.argv[1],"utf8").trim();
const t=process.argv[2];
let e=fs.existsSync(t)?fs.readFileSync(t,"utf8"):"";
const pat=/<!-- BEGIN COLDIQ -->[\s\S]*?<!-- END COLDIQ -->/;
let out=pat.test(e)?e.replace(pat,block):(e.trim()?e.replace(/\s+$/,"")+"\n\n"+block+"\n":block+"\n");
fs.mkdirSync(path.dirname(t),{recursive:true});
fs.writeFileSync(t,out);
' "$tmp" "$target"
      ;;
    *) rm -f "$tmp"; return 1 ;;
  esac
  rm -f "$tmp"
}

# ============================================================================
# Detect which agents are present
# ============================================================================
HAS_CLAUDE=false;  command -v claude  >/dev/null 2>&1 && HAS_CLAUDE=true
HAS_CURSOR=false;  { command -v cursor >/dev/null 2>&1 || [ -d "$HOME/.cursor" ]; } && HAS_CURSOR=true
HAS_CODEX=false;   { command -v codex  >/dev/null 2>&1 || [ -d "$HOME/.codex" ];  } && HAS_CODEX=true
HAS_WINDSURF=false; [ -d "$HOME/.codeium/windsurf" ] && HAS_WINDSURF=true
# Cline lives in VS Code globalStorage (platform-specific best-effort).
CLINE_DIR=""
for base in "$HOME/Library/Application Support/Code/User/globalStorage" \
            "$HOME/.config/Code/User/globalStorage" \
            "${APPDATA:-}/Code/User/globalStorage"; do
  [ -n "$base" ] && [ -d "$base/saoudrizwan.claude-dev" ] && { CLINE_DIR="$base/saoudrizwan.claude-dev/settings"; break; }
done
HAS_CLINE=false; [ -n "$CLINE_DIR" ] && HAS_CLINE=true

if ! $HAS_CLAUDE && ! $HAS_CURSOR && ! $HAS_CODEX && ! $HAS_WINDSURF && ! $HAS_CLINE; then
  err "No supported agent detected (Claude Code, Cursor, Codex, Windsurf, Cline)."
  printf '%s\n' "  Install one, then re-run. Docs: https://coldiq.com/marketplace"
  exit 1
fi

get_key "$@" || { err "No API key provided. Re-run with: COLDIQ_API_KEY=your_key bash"; exit 1; }

# ============================================================================
# Claude Code — native plugin (skills + MCP + keychain), via the plugin system
# ============================================================================
if $HAS_CLAUDE; then
  step "Claude Code"
  if claude plugin marketplace list --json 2>/dev/null | grep -q "\"name\": *\"${MARKETPLACE}\""; then
    claude plugin marketplace update "$MARKETPLACE" >/dev/null 2>&1 || true
  else
    claude plugin marketplace add "$REPO" >/dev/null 2>&1 || true
  fi
  # Enable startup auto-update (third-party marketplaces default to off).
  settings="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json"
  if [ -f "$settings" ]; then
    case "$JSON_TOOL" in
      python3)
        python3 - "$settings" "$MARKETPLACE" >/dev/null 2>&1 <<'PY' || true
import json,sys,os
try:
    p,name=sys.argv[1],sys.argv[2]; d=json.load(open(p))
    mk=d.get("extraKnownMarketplaces",{})
    if name in mk:
        mk[name]["autoUpdate"]=True
        tmp=p+".coldiq.tmp"; open(tmp,"w").write(json.dumps(d,indent=2)); os.replace(tmp,p)
except Exception: pass
PY
        ;;
      node)
        node -e '
const fs=require("fs");const [p,name]=[process.argv[1],process.argv[2]];
try{const d=JSON.parse(fs.readFileSync(p,"utf8"));
  if(d.extraKnownMarketplaces&&d.extraKnownMarketplaces[name]){
    d.extraKnownMarketplaces[name].autoUpdate=true;
    const tmp=p+".coldiq.tmp";fs.writeFileSync(tmp,JSON.stringify(d,null,2));fs.renameSync(tmp,p);}
}catch(e){}
' "$settings" "$MARKETPLACE" >/dev/null 2>&1 || true
        ;;
    esac
  fi
  if claude plugin list --json 2>/dev/null | grep -q "\"id\": *\"${PLUGIN_REF}\""; then
    claude plugin update "$PLUGIN_REF" >/dev/null 2>&1 || true
    ok "Plugin up to date (skills + MCP)."
  else
    if claude plugin install "$PLUGIN_REF" --config apiKey="$KEY" --scope user >/dev/null 2>&1; then
      ok "Plugin installed (18 skills + MCP)."
    else
      warn "Plugin install failed — run: claude plugin install ${PLUGIN_REF} --config apiKey=…"
    fi
  fi
  CONFIGURED="${CONFIGURED}\n  • ${BOLD}Claude Code${RESET}: 18 skills + MCP (restart or /reload-plugins)"
fi

# ============================================================================
# Cursor — native Skills (SKILL.md) + MCP via ~/.cursor/mcp.json
# ============================================================================
if $HAS_CURSOR; then
  step "Cursor"
  configure_mcp_json Cursor "$HOME/.cursor/mcp.json"
  if install_skills cursor; then ok "skills installed (~/.agents/skills — Cursor reads this)"; fi
  CONFIGURED="${CONFIGURED}\n  • ${BOLD}Cursor${RESET}: skills + MCP (approve the server in Settings → MCP)"
fi

# ============================================================================
# Codex — MCP via `codex mcp add` (TOML); no native skills loader → AGENTS.md
# ============================================================================
if $HAS_CODEX; then
  step "Codex"
  codex_toml="${CODEX_HOME:-$HOME/.codex}/config.toml"
  codex_done=false
  if command -v codex >/dev/null 2>&1; then
    if codex mcp list 2>/dev/null | grep -qi 'coldiq'; then
      codex_done=true; ok "MCP server already configured in ~/.codex/config.toml"
    elif codex mcp add coldiq --env COLDIQ_API_KEY="$KEY" -- npx -y @coldiq/mcp@latest >/dev/null 2>&1; then
      codex_done=true; ok "MCP server added to ~/.codex/config.toml"
    fi
    [ -f "$codex_toml" ] && { chmod 600 "$codex_toml" 2>/dev/null || true; }  # holds the key
  fi
  if ! $codex_done; then
    warn "Couldn't run 'codex mcp add' — add this to ~/.codex/config.toml manually:"
    printf '%s\n' "    ${DIM}[mcp_servers.coldiq]${RESET}"
    printf '%s\n' "    ${DIM}command = \"npx\"${RESET}"
    printf '%s\n' "    ${DIM}args = [\"-y\", \"@coldiq/mcp@latest\"]${RESET}"
    printf '%s\n' "    ${DIM}[mcp_servers.coldiq.env]${RESET}"
    printf '%s\n' "    ${DIM}COLDIQ_API_KEY = \"<your key>\"${RESET}"
  fi
  if upsert_agents_md "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"; then
    ok "ColdIQ guidance + skill instructions added to ~/.codex/AGENTS.md"
  fi
  CONFIGURED="${CONFIGURED}\n  • ${BOLD}Codex${RESET}: MCP tools + skills via list_skills (AGENTS.md guidance)"
fi

# ============================================================================
# Windsurf — MCP via ~/.codeium/windsurf/mcp_config.json
# ============================================================================
if $HAS_WINDSURF; then
  step "Windsurf"
  configure_mcp_json Windsurf "$HOME/.codeium/windsurf/mcp_config.json"
  CONFIGURED="${CONFIGURED}\n  • ${BOLD}Windsurf${RESET}: MCP tools + skills via list_skills (refresh MCP servers in Cascade)"
fi

# ============================================================================
# Cline — MCP via VS Code globalStorage cline_mcp_settings.json
# ============================================================================
if $HAS_CLINE; then
  step "Cline"
  configure_mcp_json Cline "$CLINE_DIR/cline_mcp_settings.json"
  CONFIGURED="${CONFIGURED}\n  • ${BOLD}Cline${RESET}: MCP tools + skills via list_skills"
fi

# ============================================================================
# Summary
# ============================================================================
printf '\n%s\n' "${GREEN}${BOLD}ColdIQ is ready.${RESET}"
printf '%b\n' "$CONFIGURED"
printf '\n%s\n' "  ${DIM}One key, unified credits, base URL https://api.coldiq.com${RESET}"
printf '%s\n' "  ${DIM}Re-run this command any time to update.${RESET}"
printf '\n'
