# Flask + Redis with Docker Compose

A practical Docker project demonstrating how to run a Python Flask web application and a Redis database as separate containers using Docker Compose.

The Flask application connects to Redis over the Docker Compose network and uses Redis to store a persistent page-visit counter.

---

## Project Goal

The goal of this project is to understand how multiple Docker containers can work together as a single application.

This project demonstrates:

- Building a custom Docker image for a Flask application.
- Running multiple containers with Docker Compose.
- Container-to-container networking.
- Using a Compose service name as a hostname.
- Connecting Flask to Redis.
- Using environment variables.
- Using Docker health checks.
- Using `depends_on`.
- Persisting Redis data with a Docker named volume.
- Automating the application lifecycle with Docker Compose.

---

## Architecture

```text
                         Browser
                            │
                            │ HTTP :5000
                            ▼
                   ┌─────────────────┐
                   │      Flask      │
                   │  Web Container  │
                   │ flask-redis-web │
                   └────────┬────────┘
                            │
                            │ redis:6379
                            ▼
                   ┌─────────────────┐
                   │      Redis      │
                   │ Database/Cache  │
                   │ flask-redis-db  │
                   └────────┬────────┘
                            │
                            ▼
                       redis_data
                        Volume
```

Docker Compose automatically creates a network for the services.

The Flask container connects to Redis using:

```text
redis:6379
```

The hostname `redis` comes from the Redis service name in `docker-compose.yaml`.

---

## Technologies Used

- Docker
- Docker Compose
- Python
- Flask
- Redis
- Bash
- Docker Named Volumes

---

## Project Structure

```text
Redis-Flask-Docker/
│
├── Dockerfile
├── docker-compose.yaml
├── app.py
├── requirements.txt
├── .gitignore
├── README.md
│
└── scripts/
    ├── setup.sh
    └── cleanup.sh
```

---

## Application

The Flask application contains a single route:

```text
/
```

Every time the route is accessed, the application increments a Redis counter:

```python
visits = r.incr("visits")
```

The counter is stored in Redis instead of inside the Flask container.

This allows the application and database to remain separate.

---

## Dockerfile

The Flask application is built using a Python image:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

The Dockerfile:

1. Uses Python 3.12.
2. Creates `/app` as the working directory.
3. Copies the Python dependencies.
4. Installs Flask and Redis.
5. Copies the application.
6. Exposes port 5000.
7. Starts the Flask application.

---

## Docker Compose

The Compose configuration contains two services:

```text
web
redis
```

### Flask Service

```yaml
web:
  build: .
  ports:
    - "5000:5000"
  environment:
    REDIS_HOST: redis
```

The Flask image is built from the local Dockerfile.

Port `5000` is exposed to the host machine.

The environment variable:

```text
REDIS_HOST=redis
```

tells Flask where the Redis service is located.

---

### Redis Service

```yaml
redis:
  image: redis:7-alpine
```

The project uses the lightweight Redis Alpine image.

Redis also has a health check:

```yaml
healthcheck:
  test: ["CMD", "redis-cli", "ping"]
```

This allows Docker Compose to determine whether Redis is ready.

---

## Container Networking

Docker Compose automatically creates a network for the services.

The services can communicate using their service names.

For example:

```text
Flask Container
      │
      │ redis:6379
      ▼
Redis Container
```

We don't use:

```text
localhost
```

because `localhost` inside the Flask container refers to the Flask container itself.

Instead, the Redis service name is used:

```text
redis
```

This is an important Docker networking concept.

---

## Redis Persistence

Redis uses a Docker named volume:

```yaml
volumes:
  - redis_data:/data
```

The volume is:

```text
redis_data
```

This means Redis data is stored outside the container's writable layer.

```text
Redis Container
      │
      ▼
/data
      │
      ▼
redis_data
Docker Volume
```

If the Redis container is deleted, the volume can remain and preserve the data.

---

# Setup

Clone the repository:

```bash
git clone https://github.com/amirashofteh/Docker-Projects.git
```

Navigate to the project:

```bash
cd Docker-Projects/Redis-Flask-Docker
```

Make the scripts executable:

```bash
chmod +x scripts/setup.sh scripts/cleanup.sh
```

---

# Run the Application

Start the complete application:

```bash
sudo docker-compose up -d --build
```

The `--build` option tells Docker Compose to build the Flask image using the Dockerfile.

Check the running services:

```bash
sudo docker-compose ps
```

You should see:

```text
flask-redis-web
flask-redis-db
```

---

# Test the Application

Open a browser and visit:

```text
http://localhost:5000
```

The application should display:

```text
Docker Flask + Redis

This page has been visited 1 times.
```

Refresh the page.

The counter should increase:

```text
This page has been visited 2 times.
```

Then:

```text
This page has been visited 3 times.
```

And so on.

The counter is stored in Redis.

---

# Test Redis

You can access the Redis container directly:

```bash
sudo docker exec -it flask-redis-db redis-cli
```

Inside Redis:

```text
GET visits
```

Example:

```text
"5"
```

This confirms that Redis is storing the page-visit counter.

Exit Redis:

```text
exit
```

---

# Check the Docker Network

List Docker networks:

```bash
sudo docker network ls
```

You should see a network similar to:

```text
redis-flask-docker_default
```

Inspect the network:

```bash
sudo docker network inspect redis-flask-docker_default
```

The Flask and Redis containers should both be connected to the network.

---

# Test Container Communication

From the Flask container, Redis should be reachable using its Compose service name:

```text
redis
```

The communication path is:

```text
flask-redis-web
        │
        │ TCP 6379
        ▼
flask-redis-db
```

This demonstrates Docker's internal DNS and service discovery.

---

# Health Check

Redis has a Docker health check:

```yaml
healthcheck:
  test: ["CMD", "redis-cli", "ping"]
```

Docker runs:

```bash
redis-cli ping
```

A healthy Redis server returns:

```text
PONG
```

The Flask service depends on Redis being healthy:

```yaml
depends_on:
  redis:
    condition: service_healthy
```

This helps ensure that Redis is ready before the Flask application starts.

---

# Persistence Test

First check the current Redis counter:

```bash
sudo docker exec flask-redis-db redis-cli GET visits
```

For example:

```text
"10"
```

Stop and remove the containers:

```bash
sudo docker-compose down
```

The containers are removed, but the named volume remains.

Check the volumes:

```bash
sudo docker volume ls
```

You should see a volume similar to:

```text
redis-flask-docker_redis_data
```

Start the application again:

```bash
sudo docker-compose up -d
```

Then check Redis:

```bash
sudo docker exec flask-redis-db redis-cli GET visits
```

The previous value should still exist.

This demonstrates Redis data persistence using a Docker volume.

---

# Useful Docker Commands

### Start the application

```bash
sudo docker-compose up -d
```

### Build and start

```bash
sudo docker-compose up -d --build
```

### Stop the application

```bash
sudo docker-compose stop
```

### Stop and remove containers

```bash
sudo docker-compose down
```

### View running services

```bash
sudo docker-compose ps
```

### View logs

```bash
sudo docker-compose logs
```

### View Flask logs

```bash
sudo docker-compose logs web
```

### View Redis logs

```bash
sudo docker-compose logs redis
```

---

# Cleanup

To remove the containers:

```bash
sudo docker-compose down
```

To remove the containers and the project's volume:

```bash
sudo docker-compose down -v
```

The `-v` option removes the named volume and therefore deletes the persisted Redis data.

The project also includes:

```bash
sudo ./scripts/cleanup.sh
```

for automated cleanup.

---

# What I Learned

Through this project I learned:

- How Docker Compose manages multiple containers.
- How to build a custom application image.
- How Flask communicates with Redis.
- How Docker containers communicate through a Compose network.
- How Docker service names work as DNS hostnames.
- Why `localhost` should not be used to reach another container.
- How to use environment variables in containers.
- How Docker health checks work.
- How `depends_on` can control service startup order.
- How Docker named volumes provide persistent storage.
- How to inspect Docker networks.
- How to interact with Redis using `redis-cli`.
- How to manage a multi-container application with Docker Compose.

---

# Project Results

| Test | Result |
|---|---|
| Flask image built | ✅ |
| Flask container created | ✅ |
| Redis container created | ✅ |
| Docker Compose network created | ✅ |
| Flask connected to Redis | ✅ |
| Redis health check | ✅ |
| Page counter working | ✅ |
| Redis data stored | ✅ |
| Docker volume created | ✅ |
| Redis data persisted | ✅ |
| Multi-container communication | ✅ |

---

# Key Concepts

The main concepts demonstrated by this project are:

```text
Docker Compose
      │
      ├── Flask
      │
      └── Redis
```

Container networking:

```text
Flask
  │
  │ redis:6379
  ▼
Redis
```

Persistent storage:

```text
Redis
  │
  ▼
Docker Volume
  │
  ▼
Persistent Data
```

The project demonstrates that Docker can be used to separate application components into independent containers while allowing them to communicate through an internal Docker network.

---

## Author

**Amir Ashofteh**

GitHub:

https://github.com/amirashofteh
