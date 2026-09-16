# claude-minimalistic

Claude Code with the smallest request it will send. One shell script, no dependencies.

```bash
claude-minimalistic.sh -p "say ok"
```

**-90.7% prompt tokens.** Measured, not estimated — the same prompt through the same
client, traced at the HTTP level:

```
                     baseline       minimal         saved

  prompt tokens        34,169         3,161        -90.7%
  request bytes        95,140         8,768        -90.8%
  system chars          9,160           180        -98.0%
  tool schema chars    74,144         6,328        -91.5%
  tools                    27             4        -85.2%
  message chars        12,931         1,813        -86.0%
```

## What it removes

```bash
--safe-mode                 # CLAUDE.md, skills, plugins, hooks, MCP servers, agents
--setting-sources ""        # user / project / local settings files
--strict-mcp-config         # every MCP server not named on the command line
--disable-slash-commands    # skills reachable as /name
--no-chrome                 # the browser integration
--system-prompt "..."       # REPLACES the built-in preamble
--tools Read,Write,Edit,Bash
```

Unlike `--bare`, the subscription login keeps working.

## Where the tokens actually are

Two of those flags do nearly all the work, and it is not the two most people reach for.

- **Tool schemas: 74 KB across 27 tools.** The single largest item in a stock request,
  larger than the system prompt and your CLAUDE.md put together. Four tools cost 6 KB.
- **System prompt: 9,024 characters**, resident in every request of the conversation.
- **Pre-prompt messages: 13 KB** before you have typed anything — the CLAUDE.md block,
  the skills listing, the environment preamble.

The pattern generalises: in a long-running agent the resident context — schemas,
instruction blocks, listings that sit in *every* request whether or not anything calls
them — outweighs the work the agent is actually doing. Trimming the prompt you write is
rounding error next to trimming the prompt you never see.

## Configure

```bash
SYSTEM_PROMPT="You are terse." claude-minimalistic.sh -p "..."
CLAUDE_TOOLS=Read,Bash        claude-minimalistic.sh -p "..."
CLAUDE_BIN=/path/to/claude    claude-minimalistic.sh -p "..."
```

## Trade-off

You are removing behaviour, not just bytes. Without the preamble the model is no longer
told how this harness expects its tools to be used, and without the schemas it cannot
call what you left out. For a one-shot question that is free; for a long agentic task it
is not. The interesting engineering is knowing *which* 90% is dead weight for a given
workload — that is what we do at [SuperLeanAI](https://github.com/superleanai), and this
script is the trivial end of it.

## Reproduce

Measured on Claude Code 2.1.273, Opus 5, prompt `say ok`, via a local forwarding proxy
that records system blocks, tool schemas and the token usage the API reports back. The
figures above add fresh, cache-read and cache-creation tokens, so a cached stock run is
not flattered.

## License

MIT
