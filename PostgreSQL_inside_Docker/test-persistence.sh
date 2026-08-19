#!/bin/bash

# PostgreSQL Docker Volume Project
# Persistence Test

set -e

CONTAINER_NAME="postgres-db"
NEW_CONTAINER_NAME="postgres-db-test"
VOLUME_NAME="postgres_data"
DB_NAME="mydatabase"
DB_USER="admin"
DB_PASSWORD="admin123"

echo "========================================"
echo " PostgreSQL Volume Persistence Test"
echo "========================================"

echo
echo "Stopping container '$CONTAINER_NAME'..."

sudo docker stop "$CONTAINER_NAME"

echo "Container stopped."

echo
echo "Removing container '$CONTAINER_NAME'..."

sudo docker rm "$CONTAINER_NAME"

echo "Container removed."

echo
echo "Checking if volume still exists..."

if sudo docker volume inspect "$VOLUME_NAME" &> /dev/null; then
    echo "Volume '$VOLUME_NAME' still exists. ✅"
else
    echo "ERROR: Volume '$VOLUME_NAME' was deleted!"
    exit 1
fi

echo
echo "Creating a new PostgreSQL container..."

sudo docker run -d \
    --name "$NEW_CONTAINER_NAME" \
    -e POSTGRES_USER="$DB_USER" \
    -e POSTGRES_PASSWORD="$DB_PASSWORD" \
    -e POSTGRES_DB="$DB_NAME" \
    -v "$VOLUME_NAME":/var/lib/postgresql \
    postgres

echo "New container '$NEW_CONTAINER_NAME' created."

echo
echo "Waiting for PostgreSQL to become ready..."

until sudo docker exec "$NEW_CONTAINER_NAME" pg_isready -U "$DB_USER" -d "$DB_NAME" &> /dev/null
do
    sleep 2
done

echo "PostgreSQL is ready."

echo
echo "Checking database persistence..."

RESULT=$(sudo docker exec "$NEW_CONTAINER_NAME" \
    psql -U "$DB_USER" -d "$DB_NAME" \
    -tAc "SELECT COUNT(*) FROM users;")

if [ "$RESULT" -eq 3 ]; then
    echo "Database data survived container deletion. ✅"
    echo "Users table contains $RESULT records."
else
    echo "ERROR: Expected 3 users, found $RESULT."
    exit 1
fi

echo
echo "========================================"
echo " Persistence Test: PASSED ✅"
echo "========================================"
