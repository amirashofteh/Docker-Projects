Yep 😄 — **one single `README.md`**, no separate pieces. Copy everything below into `README.md`:

````markdown
# PostgreSQL Inside Docker — Volume & Persistence

A practical Docker project demonstrating how to run PostgreSQL inside a Docker container and persist database data using a Docker named volume.

The project uses Bash scripts to automate the setup, test database persistence, and clean up the Docker environment.

## Project Goal

The goal of this project is to understand how Docker volumes provide persistent storage for containers.

This project demonstrates that:

- PostgreSQL can run inside a Docker container.
- Database data can be stored in a Docker named volume.
- A PostgreSQL container can be deleted without deleting the database data.
- A new PostgreSQL container can attach to the existing volume.
- The original database and its data remain available.

### Persistence Concept

```text
                 Docker Host
                     │
                     ▼
          ┌─────────────────────┐
          │ PostgreSQL Container│
          │    postgres-db      │
          └──────────┬──────────┘
                     │
                     │ mounted volume
                     ▼
          ┌─────────────────────┐
          │   postgres_data     │
          │    Docker Volume    │
          └──────────┬──────────┘
                     │
                     ▼
              Database Data
```

When the container is deleted:

```text
PostgreSQL Container ❌
          │
          X
          │
postgres_data Volume ✅
          │
          ▼
   Database Data
    still exists
```

A new PostgreSQL container can then attach to the same volume.

---

## Technologies Used

- Docker
- PostgreSQL
- Bash
- SQL
- Docker Named Volumes

---

## Project Structure

```text
PostgreSQL_inside_Docker/
│
├── setup.sh
├── test-persistence.sh
├── cleanup.sh
├── .gitignore
├── README.md
│
└── sql/
    └── init.sql
```

### setup.sh

Creates the PostgreSQL Docker environment.

The script:

1. Checks whether Docker is installed.
2. Creates the Docker volume if it does not exist.
3. Creates the PostgreSQL container.
4. Configures the PostgreSQL user.
5. Configures the PostgreSQL password.
6. Creates the database.
7. Mounts the Docker volume.
8. Mounts the SQL initialization script.
9. Waits until PostgreSQL is ready.

### sql/init.sql

Initializes the PostgreSQL database.

It creates a `users` table:

```sql
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL
);
```

It then inserts sample data:

```text
Amir       | DevOps Student
Docker     | Container
PostgreSQL | Database
```

### test-persistence.sh

Demonstrates Docker volume persistence.

The script:

1. Stops the original PostgreSQL container.
2. Removes the container.
3. Verifies that the Docker volume still exists.
4. Creates a new PostgreSQL container.
5. Attaches the existing Docker volume.
6. Waits for PostgreSQL to become ready.
7. Verifies that the original database data is still available.

### cleanup.sh

Removes the PostgreSQL containers and Docker volume created by the project.

---

## Setup

Clone the repository:

```bash
git clone https://github.com/amirashofteh/Docker-Projects.git
```

Navigate to the project:

```bash
cd Docker-Projects/PostgreSQL_inside_Docker
```

Make the scripts executable:

```bash
chmod +x setup.sh test-persistence.sh cleanup.sh
```

---

## Start PostgreSQL

Run:

```bash
sudo ./setup.sh
```

The script creates:

```text
Docker Volume:
postgres_data

Container:
postgres-db

Database:
mydatabase

User:
admin
```

The PostgreSQL data is stored in the Docker volume:

```text
postgres_data
      │
      ▼
/var/lib/postgresql
```

---

## Verify the Container

Check the running container:

```bash
sudo docker ps
```

You should see:

```text
postgres-db
```

---

## Connect to PostgreSQL

Connect to the database:

```bash
sudo docker exec -it postgres-db psql -U admin -d mydatabase
```

List the database tables:

```sql
\dt
```

Expected result:

```text
 Schema | Name  | Type  | Owner
--------+-------+-------+-------
 public | users | table | admin
```

Check the stored data:

```sql
SELECT * FROM users;
```

Expected result:

```text
 id |    name    |      role
----+------------+----------------
  1 | Amir       | DevOps Student
  2 | Docker     | Container
  3 | PostgreSQL | Database
```

Exit PostgreSQL:

```sql
\q
```

---

## Test Docker Volume Persistence

Run:

```bash
sudo ./test-persistence.sh
```

The script performs the following experiment:

```text
             postgres-db
                  │
                  ▼
            Stop Container
                  │
                  ▼
           Delete Container
                  │
                  ▼
        postgres_data survives
                  │
                  ▼
        Create New Container
                  │
                  ▼
        Attach Same Volume
                  │
                  ▼
        Recover Database Data
```

The important concept is:

```text
Container = Disposable
Volume    = Persistent
```

---

## Verify Persistence

After the persistence test creates the new container:

```bash
sudo docker ps
```

You should see:

```text
postgres-db-test
```

Connect to the new container:

```bash
sudo docker exec -it postgres-db-test psql -U admin -d mydatabase
```

Run:

```sql
SELECT * FROM users;
```

The original records should still exist:

```text
 id |    name    |      role
----+------------+----------------
  1 | Amir       | DevOps Student
  2 | Docker     | Container
  3 | PostgreSQL | Database
```

This proves that the database survived the deletion of the original PostgreSQL container.

---

## Docker Volume Verification

List Docker volumes:

```bash
sudo docker volume ls
```

You should see:

```text
postgres_data
```

Inspect the volume:

```bash
sudo docker volume inspect postgres_data
```

The volume exists independently from the PostgreSQL container.

---

## Cleanup

When finished with the project, run:

```bash
sudo ./cleanup.sh
```

The cleanup script removes:

```text
postgres-db
postgres-db-test
postgres_data
```

This completely removes the Docker resources created by the project.

---

## What I Learned

Through this project I learned:

- How to run PostgreSQL inside Docker.
- How Docker named volumes work.
- How to attach a volume to a container.
- The difference between container storage and persistent storage.
- How PostgreSQL initializes a database inside Docker.
- How SQL initialization scripts work with the PostgreSQL Docker image.
- How `/docker-entrypoint-initdb.d/` is used for database initialization.
- How to automate Docker operations using Bash.
- How to check PostgreSQL readiness using `pg_isready`.
- How to use `docker exec` to interact with a running database.
- How database data can survive container deletion.
- How to build a reproducible Docker project for GitHub.

---

## Persistence Test Results

| Test | Result |
|---|---|
| PostgreSQL image available | ✅ |
| Docker volume created | ✅ |
| PostgreSQL container created | ✅ |
| Database initialized | ✅ |
| `users` table created | ✅ |
| Sample data inserted | ✅ |
| Original container stopped | ✅ |
| Original container deleted | ✅ |
| Docker volume preserved | ✅ |
| New PostgreSQL container created | ✅ |
| Existing volume attached | ✅ |
| Existing database recovered | ✅ |
| Existing data preserved | ✅ |

---

## Key Concept

The main lesson of this project is:

```text
Container ≠ Data
```

A Docker container is replaceable and disposable.

Important application data should be stored using persistent storage such as Docker volumes.

```text
        Container
            │
            │ uses
            ▼
      Docker Volume
            │
            │ stores
            ▼
      Persistent Data
```

Therefore, deleting a container does not necessarily mean losing the application's data.

---

## Author

**Amir Ashofteh**

GitHub:

https://github.com/amirashofteh
````
