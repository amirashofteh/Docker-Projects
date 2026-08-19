#!/bin/bash

#PostgreSQL Docker Volume Project 
#Setup Script 

set -e 

CONTAINER_NAME="postgres-db"
VOLUME_NAME="postgres_data"
DB_NAME="mydatabase"
DB_USER="admin"
DB_PASSWORD="admin123"

#Check if Docker is Installed 

if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed."
    exit 1
fi

echo "Docker is installed."

#Check if Volume exists

if docker volume inspect "$VOLUME_NAME" &> /dev/null; then
    echo "Docker volume '$VOLUME_NAME' already exists."
else
    echo "Creating Docker volume '$VOLUME_NAME'..."
    docker volume create "$VOLUME_NAME"
fi

#Check if Container exists or not 

if docker container inspect "$CONTAINER_NAME" &> /dev/null; then
    echo "Container '$CONTAINER_NAME' already exists."
else
    echo "Creating PostgreSQL container '$CONTAINER_NAME'..."

    docker run -d \
        --name "$CONTAINER_NAME" \
        -e POSTGRES_USER="$DB_USER" \
        -e POSTGRES_PASSWORD="$DB_PASSWORD" \
        -e POSTGRES_DB="$DB_NAME" \
        -v "$VOLUME_NAME":/var/lib/postgresql \
	-v "$(pwd)/sql/init.sql":/docker-entrypoint-initdb.d/init.sql:ro \
        postgres
fi

#Check if PostgreSQL is ready or not 

echo "Waiting for PostgreSQL to become ready..."

until docker exec "$CONTAINER_NAME" pg_isready -U "$DB_USER" -d "$DB_NAME" &> /dev/null
do
    sleep 2
done

echo "PostgreSQL is ready."

