#!/bin/bash

AGENT_DIR="$(dirname "$0")"

SOUL="$AGENT_DIR/soul.md"
HEARTBEAT="$AGENT_DIR/heartbeat.md"
MEMORY="$AGENT_DIR/memory.md"
LOG="$AGENT_DIR/log.txt"

# Build prompt
PROMPT=$(cat "$SOUL" "$HEARTBEAT" "$MEMORY")

# Call Ollama
RESPONSE=$(ollama run gemma4:e2b "$PROMPT")

# Log it
echo "=== $(date) ===" >> "$LOG"
echo "$RESPONSE" >> "$LOG"
echo "" >> "$LOG"

# If response contains a shell command block, run it
CMD=$(echo "$RESPONSE" | sed -n '/^```sh$/,/^```$/p' | grep -v '^```')
if [ -n "$CMD" ]; then
    echo "--- running command ---" >> "$LOG"
    eval "$CMD" >> "$LOG" 2>&1
fi

# If response contains a MEMORY block, overwrite memory.txt
MEM=$(echo "$RESPONSE" | sed -n '/^```memory$/,/^```$/p' | grep -v '^```')
if [ -n "$MEM" ]; then
    echo "$MEM" > "$MEMORY"
fi
