# 🐳 Docker Persistent Storage & Backup

A practical Docker project demonstrating **persistent PostgreSQL storage, database backups, and disaster recovery** using Docker volumes and Bash scripts.

## 🎯 Project Goal

Learn how to:

* Persist PostgreSQL data using Docker named volumes
* Create database backups with `pg_dump`
* Simulate complete data loss
* Restore a PostgreSQL database from a backup
* Automate backup and restore operations with Bash

## 🏗️ Architecture

```text
PostgreSQL Container
        │
        ▼
 Docker Named Volume
   postgres_data
        │
        ▼
 Persistent Database
        │
        ├── backup.sh
        │       │
        │       ▼
        │   SQL Backup
        │
        └── restore.sh
                │
                ▼
          Database Recovery
```

## 📁 Project Structure

```text
Docker_Persistant_Storage_Backup/
├── docker-compose.yml
├── database/
│   └── init.sql
└── backup/
    ├── backup.sh
    ├── restore.sh
    └── backups/
        └── postgres_*.sql
```

## 🚀 Setup

Start PostgreSQL:

```bash
sudo docker compose up -d
```

Check the container:

```bash
sudo docker compose ps
```

## 🗄️ Test Persistent Storage

Create sample data:

```bash
sudo docker exec -it postgres-backup psql -U appuser -d appdb
```

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');
```

Verify:

```sql
SELECT * FROM users;
```

Remove and recreate the container:

```bash
sudo docker rm -f postgres-backup
sudo docker compose up -d
```

Verify the data again:

```bash
sudo docker exec postgres-backup \
psql -U appuser -d appdb -c "SELECT * FROM users;"
```

The data remains because it is stored in the Docker volume.

## 💾 Create a Backup

Run:

```bash
./backup/backup.sh
```

Backups are stored in:

```text
backup/backups/
```

Example:

```text
postgres_2026-09-05_12-51-12.sql
```

## 🔥 Disaster Recovery Test

Remove the PostgreSQL container and volume:

```bash
sudo docker compose down
sudo docker volume rm docker_persistant_storage_backup_postgres_data
```

Recreate PostgreSQL:

```bash
sudo docker compose up -d
```

The database is now empty.

## ♻️ Restore the Database

Run:

```bash
./backup/restore.sh backup/backups/postgres_2026-09-05_12-51-12.sql
```

Verify the restored data:

```bash
sudo docker exec postgres-backup \
psql -U appuser -d appdb -c "SELECT * FROM users;"
```

Expected:

```text
 id | name  |       email
----+-------+-------------------
  1 | Alice | alice@example.com
  2 | Bob   | bob@example.com
```

## 🧠 What I Learned

* Docker named volumes
* Persistent container storage
* PostgreSQL data management
* `pg_dump`
* PostgreSQL restore
* Bash scripting
* Backup and recovery workflows
* Disaster recovery testing
* Difference between container lifecycle and persistent data

## ✅ Project Result

The project successfully demonstrates:

```text
Persistent Storage    ✅
Container Recreation  ✅
Database Backup       ✅
Data Loss Simulation  ✅
Database Restore      ✅
Disaster Recovery     ✅
```

This project represents a basic real-world **Docker backup and disaster recovery workflow**.
