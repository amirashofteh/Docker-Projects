#!/bin/bash

# PostgreSQL Docker Volume Project
# Cleanup Script

set -e

CONTAINER_NAME="postgres-db"
NEW_CONTAINER_NAME="postgres-db-test"
VOLUME_NAME="postgres_data"

echo "========================================"
echo " PostgreSQL Docker Cleanup"
echo "========================================"

if sudo docker container inspect "$CONTAINER_NAME" &> /dev/null; then
    echo "Removing container '$CONTAINER_NAME'..."
    sudo docker rm -f "$CONTAINER_NAME"
else
    echo "Container '$CONTAINER_NAME' does not exist."
fi

if sudo docker container inspect "$NEW_CONTAINER_NAME" &> /dev/null; then
    echo "Removing container '$NEW_CONTAINER_NAME'..."
    sudo docker rm -f "$NEW_CONTAINER_NAME"
else
    echo "Container '$NEW_CONTAINER_NAME' does not exist."
fi

if sudo docker volume inspect "$VOLUME_NAME" &> /dev/null; then
    echo "Removing volume '$VOLUME_NAME'..."
    sudo docker volume rm "$VOLUME_NAME"
else
    echo "Volume '$VOLUME_NAME' does not exist."
fi

echo
echo "Cleanup completed."
