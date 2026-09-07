# Docker Compose Production Application

A multi-container production-style application built with Docker Compose.

The project demonstrates how multiple services communicate through a Docker Compose network and how persistent PostgreSQL storage and reverse proxying work together.

## Architecture

```text
                    ┌───────────────┐
                    │     Nginx     │
                    │     :80       │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │    Node.js    │
                    │    :3000      │
                    └───────┬───────┘
                       ┌────┴────┐
                       │         │
                       ▼         ▼
                ┌──────────┐ ┌─────────┐
                │PostgreSQL│ │  Redis  │
                │  :5432   │ │  :6379  │
                └──────────┘ └─────────┘
```

## Services

| Service    | Image / Build       | Purpose             |
| ---------- | ------------------- | ------------------- |
| Nginx      | `nginx:alpine`      | Reverse proxy       |
| Node.js    | Custom Docker image | Application server  |
| PostgreSQL | `postgres:17`       | Relational database |
| Redis      | `redis:7-alpine`    | In-memory cache     |

## Project Structure

```text
Docker_Compose_Production_App/
├── docker-compose.yml
├── nginx/
│   └── nginx.conf
├── node/
│   ├── Dockerfile
│   ├── package.json
│   ├── package-lock.json
│   └── server.js
└── postgres/
```

## Docker Compose Concepts Practiced

### Compose Networking

Services communicate using their Compose service names instead of `localhost`.

For example:

```text
Node.js → postgres:5432
Node.js → redis:6379
Nginx → node:3000
```

### Environment Variables

PostgreSQL is configured through Compose environment variables:

```yaml
POSTGRES_USER: appuser
POSTGRES_PASSWORD: apppassword
POSTGRES_DB: appdb
```

### Volumes

PostgreSQL uses a named volume:

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
```

This keeps database data outside the container filesystem.

### Dependencies

Nginx uses:

```yaml
depends_on:
  - node
```

This ensures Node.js is started before Nginx.

### Reverse Proxy

Nginx receives requests on port `80` and forwards them to Node.js:

```nginx
location / {
    proxy_pass http://node:3000;
}
```

## Application Endpoints

### Application

```text
GET /
```

Returns:

```json
{
  "message": "Node.js application is running"
}
```

### Health Endpoint

```text
GET /health
```

Returns:

```json
{
  "status": "healthy"
}
```

### PostgreSQL Test

```text
GET /db
```

Tests the Node.js → PostgreSQL connection.

Example:

```json
{
  "database": "connected",
  "time": "2026-09-05T07:39:20.865Z"
}
```

### Redis Test

```text
GET /cache
```

Tests the Node.js → Redis connection.

Example:

```json
{
  "cache": "connected",
  "value": "Hello from Redis!"
}
```

## Running the Project

Start the application:

```bash
sudo docker compose up -d
```

Rebuild the Node.js image when required:

```bash
sudo docker compose up -d --build
```

Check running services:

```bash
sudo docker compose ps
```

View logs:

```bash
sudo docker compose logs
```

Stop the project:

```bash
sudo docker compose down
```

## Testing

Test Nginx → Node.js:

```bash
curl http://localhost
```

Test Node.js → PostgreSQL:

```bash
curl http://localhost:3000/db
```

Test Node.js → Redis:

```bash
curl http://localhost:3000/cache
```

## What I Learned

* Creating multi-container applications with Docker Compose
* Docker Compose service networking
* Communication between containers using service names
* Building a Node.js Docker image
* Connecting Node.js to PostgreSQL
* Connecting Node.js to Redis
* Using Nginx as a reverse proxy
* Using Compose environment variables
* Using named Docker volumes for persistent data
* Using `depends_on`
* Managing a complete application stack with Docker Compose

## Project Status

**Completed ✅**

Stack:

```text
Nginx
  ↓
Node.js
  ├── PostgreSQL
  └── Redis
```
