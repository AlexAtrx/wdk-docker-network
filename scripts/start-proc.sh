#!/bin/bash
# start-proc.sh <key_file> <command...>
# Example: ./start-proc.sh /shared/keys/evm.key node worker.js ...

set -e

KEY_FILE="$1"
shift
CMD="$@"

# Ensure directory exists
mkdir -p "$(dirname "$KEY_FILE")"
# Clear old key
rm -f "$KEY_FILE"

echo ">>> Starting Proc Worker..."
echo ">>> Key will be written to: $KEY_FILE"
echo ">>> Command: $CMD"

# We use awk to simultaneously print to stdout and capture the key
# logic: print every line. if line matches regex, write capture group to file.
# We explicitly flush output (-W interactive in awk isn't always avaialble, but stdbuf might help)

# Using a while read loop is safer for simple string matching without buffering issues of some awks
# We execute command, 2>&1 to capture stderr too if needed (logger usually goes to stdout or stderr)
# We need to make sure we don't block the command.

$CMD 2>&1 | while IFS= read -r line; do
    echo "$line"
    # Match "rpc public key: <hex>"
    if [[ "$line" =~ rpc\ public\ key:\ ([a-fA-F0-9]+) ]]; then
        KEY="${BASH_REMATCH[1]}"
        echo "$KEY" > "$KEY_FILE"
        echo ">>> CAPTURED KEY: $KEY"
    fi
done
