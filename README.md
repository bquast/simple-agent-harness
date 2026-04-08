# simple-agent-harness

A minimal autonomous LLM agent. No framework, no dependencies beyond Ollama.

## files

| file | purpose |
|---|---|
| soul.md | identity and behavioral rules |
| heartbeat.md | prompt sent to the LLM every 30 minutes |
| memory.md | persistent memory, rewritten by the LLM when needed |
| log.txt | append-only record of every response and action |
| agent.sh | the script that ties it all together |
| cron.txt | the cron schedule |

## setup

1. Install Ollama: `curl -fsSL https://ollama.com/install.sh | sh`
2. Pull a model: `ollama pull gemma4:e2b`
3. Make the script executable: `chmod +x agent.sh`
4. Install the cron job: `crontab cron.txt` (adjust the path first)

## conventions

The LLM can take two actions by wrapping content in fenced blocks:

- `​```sh` — shell command, executed immediately, output logged
- `​```memory` — replaces the contents of memory.txt

Everything else is logged to log.txt and ignored.

## files not to edit manually

`memory.md` and `log.txt` are owned by the agent at runtime.