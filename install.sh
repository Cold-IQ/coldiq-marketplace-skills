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
#   curl -fsSL .../install.sh | COLDIQ_API_KEY=ciq_live_xxx bash
#   curl -fsSL .../install.sh | bash -s -- ciq_live_xxx

set -uo pipefail

REPO="Cold-IQ/coldiq-marketplace-skills"
MARKETPLACE="coldiq"
PLUGIN="coldiq"
PLUGIN_REF="${PLUGIN}@${MARKETPLACE}"
MCP_CMD="npx"
MCP_PKG="@coldiq/mcp@latest"
MCP_ARGS_JSON="[\"-y\",\"${MCP_PKG}\"]"
API_BASE="https://api.coldiq.com"

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
    ok "MCP server written to ${path/#"$HOME"/\~}"
  elif [ "$rc" -eq 3 ]; then
    warn "${path/#"$HOME"/\~} exists but isn't valid JSON — left it untouched."
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
  # Only prompt when /dev/tty is actually usable. `[ -r /dev/tty ]` is not
  # enough: in containers/CI the node exists and is mode-readable but open()
  # fails with "No such device or address", which used to print an
  # unanswerable password prompt plus raw /dev/tty errors. The stty probe
  # performs a real open, so we fall through to the clean no-key exit instead.
  # (The { } group is required: a failed `</dev/tty` open aborts the command
  # BEFORE its own 2>&1 applies, so bash's error would leak without it.)
  if [ -z "$KEY" ] && [ -e /dev/tty ] && { stty -g </dev/tty; } >/dev/null 2>&1; then
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

# Read-only probe that the key is actually live, before we write it into every
# agent config on the machine. Costs no credits. Only a definitive rejection
# (401/403) fails: anything else — no curl, offline, DNS blocked, upstream 5xx —
# is inconclusive and must not block an otherwise fine install.
verify_key() {
  command -v curl >/dev/null 2>&1 || return 0
  code="$(curl -sS -o /dev/null -w '%{http_code}' -m 10 \
            -H "Authorization: Bearer ${KEY}" \
            "${API_BASE}/v1/me/credits" </dev/null 2>/dev/null || true)"
  case "$code" in
    401|403) return 1 ;;
    *)       return 0 ;;
  esac
}

# Install skills into a skill-native agent via vercel-labs/skills.
# `</dev/null` matters: on the `curl | bash` path stdin IS the script, and the
# skills CLI drains stdin — see the note above main().
install_skills() {
  agent="$1"
  command -v npx >/dev/null 2>&1 || { warn "npx not found — skipping ${agent} skills (install Node.js)."; return 1; }
  if ! npx -y skills@latest add "$REPO" --agent "$agent" --global --yes </dev/null >/dev/null 2>&1; then
    warn "skills CLI failed for ${agent} — retry manually: npx skills@latest add ${REPO} --agent ${agent} --global"
    return 1
  fi
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
# main — the entire execution flow lives here, with `main "$@"` as the very
# last line of the file. On the shipped `curl … | bash` path, bash reads the
# script lazily from the SAME stdin pipe it hands to child processes; a child
# that drains stdin (npx, the claude/codex CLIs) therefore used to eat the
# unread remainder of the script, silently skipping every later agent block.
# Wrapping the flow in one function forces bash to parse the whole body before
# executing any of it, so no child can truncate the install. The `</dev/null`
# redirects on stdin-hungry children below are belt-and-braces on top of that.
# ============================================================================
main() {
  printf '\n%s\n' "${BOLD}ColdIQ — installer for AI coding agents${RESET}"

  # --------------------------------------------------------------------------
  # Detect which agents are present
  # --------------------------------------------------------------------------
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

  if ! verify_key; then
    err "That API key was rejected by ${API_BASE} — nothing was configured."
    printf '%s\n' "  Copy a valid key from ${BOLD}https://coldiq.com/marketplace${RESET} ${DIM}(dashboard → API keys)${RESET}, then re-run."
    exit 1
  fi

  # --------------------------------------------------------------------------
  # Claude Code — native plugin (skills + MCP + keychain), via the plugin system
  # --------------------------------------------------------------------------
  if $HAS_CLAUDE; then
    step "Claude Code"
    if claude plugin marketplace list --json </dev/null 2>/dev/null | grep -q "\"name\": *\"${MARKETPLACE}\""; then
      claude plugin marketplace update "$MARKETPLACE" </dev/null >/dev/null 2>&1 || true
    else
      claude plugin marketplace add "$REPO" </dev/null >/dev/null 2>&1 || true
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
    # The plugin's .mcp.json binds COLDIQ_API_KEY to ${user_config.apiKey}, and
    # that value only ever reaches the plugin through `plugin install --config`.
    # Two CLI behaviours made a re-run unable to repair a keyless install:
    # `plugin update` takes no --config at all, and `plugin install --config` is
    # a silent no-op once the plugin exists. So an install that ever landed
    # without a key stayed keyless forever — every re-run cheerfully reported
    # "up to date" while the MCP server shipped an unresolved placeholder and
    # 401'd on every tool call. There is no supported way to read the stored
    # config back (sensitive values live in the OS keychain), so we can't detect
    # the bad state — we unconditionally route the key through the install path
    # instead. Uninstall + install is cheap (the marketplace clone is already
    # local) and the net effect is idempotent.
    if claude plugin list --json </dev/null 2>/dev/null | grep -q "\"id\": *\"${PLUGIN_REF}\""; then
      claude plugin update "$PLUGIN_REF" </dev/null >/dev/null 2>&1 || true
      claude plugin uninstall "$PLUGIN_REF" --scope user </dev/null >/dev/null 2>&1 || true
    fi
    if claude plugin install "$PLUGIN_REF" --config apiKey="$KEY" --scope user </dev/null >/dev/null 2>&1; then
      # A previous run may have taken the standalone fallback below; the plugin
      # now provides the same server, so drop the duplicate. No-op if absent.
      claude mcp remove coldiq --scope user </dev/null >/dev/null 2>&1 || true
      ok "Plugin installed with your API key (18 skills + MCP)."
    else
      # Older CLI without --config, or a rejected manifest. Restore the skills,
      # then register the MCP server standalone so the tools still work.
      claude plugin install "$PLUGIN_REF" --scope user </dev/null >/dev/null 2>&1 || true
      if claude mcp add coldiq --scope user --env COLDIQ_API_KEY="$KEY" \
           -- "$MCP_CMD" -y "$MCP_PKG" </dev/null >/dev/null 2>&1; then
        warn "Plugin couldn't take the API key — registered the MCP server standalone instead."
      else
        warn "Couldn't wire the MCP server — run: claude plugin install ${PLUGIN_REF} --config apiKey=…"
      fi
    fi
    CONFIGURED="${CONFIGURED}\n  • ${BOLD}Claude Code${RESET}: 18 skills + MCP (restart or /reload-plugins)"
  fi

  # --------------------------------------------------------------------------
  # Cursor — native Skills (SKILL.md) + MCP via ~/.cursor/mcp.json
  # --------------------------------------------------------------------------
  if $HAS_CURSOR; then
    step "Cursor"
    configure_mcp_json Cursor "$HOME/.cursor/mcp.json"
    if install_skills cursor; then
      ok "skills installed (~/.agents/skills — Cursor reads this)"
    else
      warn "Cursor skills not installed — MCP still works; skills add the GTM playbooks."
    fi
    CONFIGURED="${CONFIGURED}\n  • ${BOLD}Cursor${RESET}: skills + MCP (approve the server in Settings → MCP)"
  fi

  # --------------------------------------------------------------------------
  # Codex — MCP via `codex mcp add` (TOML); no native skills loader → AGENTS.md
  # --------------------------------------------------------------------------
  if $HAS_CODEX; then
    step "Codex"
    codex_toml="${CODEX_HOME:-$HOME/.codex}/config.toml"
    codex_done=false
    if command -v codex >/dev/null 2>&1; then
      if codex mcp list </dev/null 2>/dev/null | grep -qi 'coldiq'; then
        codex_done=true; ok "MCP server already configured in ~/.codex/config.toml"
      elif codex mcp add coldiq --env COLDIQ_API_KEY="$KEY" -- npx -y @coldiq/mcp@latest </dev/null >/dev/null 2>&1; then
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
    else
      warn "Couldn't update ~/.codex/AGENTS.md — ColdIQ skills guidance not installed (needs curl and python3 or node)."
    fi
    CONFIGURED="${CONFIGURED}\n  • ${BOLD}Codex${RESET}: MCP tools + skills via list_skills (AGENTS.md guidance)"
  fi

  # --------------------------------------------------------------------------
  # Windsurf — MCP via ~/.codeium/windsurf/mcp_config.json
  # --------------------------------------------------------------------------
  if $HAS_WINDSURF; then
    step "Windsurf"
    configure_mcp_json Windsurf "$HOME/.codeium/windsurf/mcp_config.json"
    CONFIGURED="${CONFIGURED}\n  • ${BOLD}Windsurf${RESET}: MCP tools + skills via list_skills (refresh MCP servers in Cascade)"
  fi

  # --------------------------------------------------------------------------
  # Cline — MCP via VS Code globalStorage cline_mcp_settings.json
  # --------------------------------------------------------------------------
  if $HAS_CLINE; then
    step "Cline"
    configure_mcp_json Cline "$CLINE_DIR/cline_mcp_settings.json"
    CONFIGURED="${CONFIGURED}\n  • ${BOLD}Cline${RESET}: MCP tools + skills via list_skills"
  fi

  # --------------------------------------------------------------------------
  # Summary
  # --------------------------------------------------------------------------
  printf '\n%s\n' "${GREEN}${BOLD}ColdIQ is ready.${RESET}"
  printf '%b\n' "$CONFIGURED"
  printf '\n%s\n' "  ${DIM}One key, unified credits, base URL https://api.coldiq.com${RESET}"
  printf '%s\n' "  ${DIM}Re-run this command any time to update.${RESET}"
  printf '\n'
}

main "$@"
