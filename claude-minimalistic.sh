#!/bin/bash
# Claude Code with the smallest possible request: no default system prompt, no
# CLAUDE.md, no skills, no MCP servers, no hooks/plugins/agents, and only the
# four tools that actually do work (Read, Write, Edit, Bash).
#
# What each flag removes:
#   --safe-mode              CLAUDE.md, skills, plugins, hooks, MCP servers,
#                            custom commands and agents, output styles
#   --setting-sources ""     user / project / local settings files
#   --strict-mcp-config      every MCP server not passed on the command line
#   --disable-slash-commands skills reachable as /name
#   --system-prompt "..."    REPLACES the built-in system prompt (which carries
#                            the tool preamble, harness notes and policies)
#   --tools ...              the built-in tool set, minus the four kept here
#   --no-chrome              the Claude in Chrome integration
#
# OAuth still applies: unlike --bare, this keeps the subscription login.
#
# Usage:
#   claude-minimalistic.sh -p "say ok"        # one shot
#   claude-minimalistic.sh                    # interactive
#   SYSTEM_PROMPT="You are terse." claude-minimalistic.sh -p "say ok"
#   CLAUDE_TOOLS=Read,Bash claude-minimalistic.sh -p "..."

set -euo pipefail

CLAUDE_BIN=${CLAUDE_BIN:-$(command -v claude)}
SYSTEM_PROMPT=${SYSTEM_PROMPT:-You are Claude Code, a CLI coding assistant.}
CLAUDE_TOOLS=${CLAUDE_TOOLS:-Read,Write,Edit,Bash}

exec "$CLAUDE_BIN" \
  --safe-mode \
  --setting-sources "" \
  --strict-mcp-config \
  --disable-slash-commands \
  --no-chrome \
  --system-prompt "$SYSTEM_PROMPT" \
  --tools "$CLAUDE_TOOLS" \
  "$@"
