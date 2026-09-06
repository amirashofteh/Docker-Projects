#!/bin/bash

CONTAINER="resource-stress"

if ! sudo docker inspect "$CONTAINER" >/dev/null 2>&1; then
    echo "Container '$CONTAINER' does not exist."
    exit 1
fi

echo "Monitoring: $CONTAINER"
echo "Press Ctrl+C to stop."

while true; do
    clear

    echo "========================================"
    echo " Docker Resource Monitor"
    echo "========================================"
    echo

    sudo docker stats "$CONTAINER" --no-stream \
        --format "CPU: {{.CPUPerc}}
Memory: {{.MemUsage}}
Memory %: {{.MemPerc}}
PIDs: {{.PIDs}}"

    echo
    sudo docker inspect "$CONTAINER" \
        --format "Status={{.State.Status}} OOMKilled={{.State.OOMKilled}}"

    sleep 2
done
