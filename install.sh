#!/usr/bin/env bash
#
# ColdIQ Marketplace — one-command installer & updater for Claude Code.
#
# Installs (or updates) the ColdIQ plugin: 18 GTM skills + the ColdIQ MCP server,
# all wired to https://api.coldiq.com with one API key and unified credits.
#
# Usage (install or update — safe to re-run):
#   curl -fsSL https://raw.githubusercontent.com/Cold-IQ/coldiq-marketplace-skills/main/install.sh | bash
#
# Provide your API key non-interactively (skips the prompt) any of these ways:
#   curl -fsSL .../install.sh | COLDIQ_API_KEY=ck_live_xxx bash
#   curl -fsSL .../install.sh | bash -s -- ck_live_xxx
#
# Re-running this script updates the plugin to the latest version on GitHub.

set -euo pipefail

MARKETPLACE_SOURCE="Cold-IQ/coldiq-marketplace-skills"
MARKETPLACE="coldiq"
PLUGIN="coldiq"
PLUGIN_REF="${PLUGIN}@${MARKETPLACE}"

# --- pretty output (degrades gracefully when not a TTY) -----------------------
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

printf '\n%s\n\n' "${BOLD}ColdIQ Marketplace — Claude Code installer${RESET}"

# --- 1. prerequisites ---------------------------------------------------------
if ! command -v claude >/dev/null 2>&1; then
  err "The Claude Code CLI ('claude') was not found on your PATH."
  printf '%s\n' "  Install it first: ${BOLD}https://code.claude.com/docs/en/quickstart${RESET}"
  printf '%s\n' "  Then re-run this command."
  exit 1
fi
ok "Found Claude Code: $(claude --version 2>/dev/null || echo 'unknown version')"

# --- 2. ensure the marketplace is registered, then refresh it -----------------
if claude plugin marketplace list --json 2>/dev/null | grep -q "\"name\": *\"${MARKETPLACE}\""; then
  info "Refreshing the ColdIQ marketplace…"
  claude plugin marketplace update "$MARKETPLACE" >/dev/null
else
  info "Adding the ColdIQ marketplace…"
  claude plugin marketplace add "$MARKETPLACE_SOURCE" >/dev/null
fi
ok "Marketplace '${MARKETPLACE}' is registered and up to date."

# --- 3. install (first run) or update (subsequent runs) -----------------------
if claude plugin list --json 2>/dev/null | grep -q "\"id\": *\"${PLUGIN_REF}\""; then
  info "Plugin already installed — checking for updates…"
  claude plugin update "$PLUGIN_REF"
  ok "ColdIQ plugin is up to date."
else
  # First install needs the API key (stored securely in your OS keychain).
  KEY="${COLDIQ_API_KEY:-}"
  [ "$#" -ge 1 ] && [ -n "${1:-}" ] && KEY="$1"

  if [ -z "$KEY" ]; then
    if [ -r /dev/tty ]; then
      printf '\n%s\n' "${BOLD}Enter your ColdIQ API key${RESET} ${DIM}(create one at https://coldiq.com/marketplace → API keys)${RESET}"
      printf 'API key: '
      # Read without echoing to the screen. Always restore echo, even on Ctrl-C.
      trap 'stty echo </dev/tty 2>/dev/null || true' EXIT INT TERM
      stty -echo </dev/tty 2>/dev/null || true
      IFS= read -r KEY </dev/tty || true
      stty echo </dev/tty 2>/dev/null || true
      trap - EXIT INT TERM
      printf '\n'
    fi
  fi

  if [ -z "$KEY" ]; then
    err "No API key provided."
    printf '%s\n' "  Re-run with your key, e.g.:"
    printf '%s\n' "    ${BOLD}curl -fsSL https://raw.githubusercontent.com/${MARKETPLACE_SOURCE}/main/install.sh | COLDIQ_API_KEY=your_key bash${RESET}"
    exit 1
  fi

  info "Installing the ColdIQ plugin (18 skills + MCP server)…"
  claude plugin install "$PLUGIN_REF" --config apiKey="$KEY" --scope user
  ok "ColdIQ plugin installed."
fi

# --- 4. heads-up about a conflicting manually-added MCP server ----------------
if claude mcp get "$PLUGIN" >/dev/null 2>&1; then
  warn "You also have a manually-added MCP server named '${PLUGIN}'."
  printf '%s\n' "  It will duplicate the plugin's tools. Remove it with: ${BOLD}claude mcp remove ${PLUGIN}${RESET}"
fi

# --- done ---------------------------------------------------------------------
printf '\n%s\n' "${GREEN}${BOLD}ColdIQ is ready.${RESET}"
printf '%s\n' "  • ${BOLD}Restart Claude Code${RESET} (or run ${BOLD}/reload-plugins${RESET}) to load the MCP server."
printf '%s\n' "  • 18 GTM skills are now available — they activate automatically, or list them with ${BOLD}/plugin${RESET}."
printf '%s\n' "  • Update anytime by re-running this command, or: ${BOLD}claude plugin marketplace update ${MARKETPLACE} && claude plugin update ${PLUGIN_REF}${RESET}"
printf '\n'
