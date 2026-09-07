#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="backup/backups"
BACKUP_FILE="$BACKUP_DIR/postgres_${TIMESTAMP}.sql"

mkdir -p "$BACKUP_DIR"

sudo docker exec postgres-backup pg_dump \
    -U appuser \
    -d appdb \
    > "$BACKUP_FILE"

echo "Backup created: $BACKUP_FILE"
