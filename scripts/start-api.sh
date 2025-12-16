#!/bin/bash
# start-api.sh <key_file> <command...>
# Example: ./start-api.sh /shared/keys/evm.key node worker.js ...

set -e

KEY_FILE="$1"
shift
CMD="$@"

echo ">>> Waiting for key file: $KEY_FILE"

while [ ! -s "$KEY_FILE" ]; do
    sleep 2
    echo ">>> Waiting for key..."
done

KEY=$(cat "$KEY_FILE")
echo ">>> Found key: $KEY"

echo ">>> Starting API Worker..."
# We append --proc-rpc <KEY> to the command
FINAL_CMD="$CMD --proc-rpc $KEY"
echo ">>> Command: $FINAL_CMD"

exec $FINAL_CMD
