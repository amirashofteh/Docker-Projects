\#!/bin/bash

BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup-file>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found: $BACKUP_FILE"
    exit 1
fi

sudo docker exec -i postgres-backup \
    psql -U appuser -d appdb < "$BACKUP_FILE"

echo "Database restored from: $BACKUP_FILE"
