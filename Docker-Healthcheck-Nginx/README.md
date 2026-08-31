# Nginx Docker Healthcheck

A simple Docker Compose project demonstrating how to run an Nginx web server inside a Docker container and use a Docker healthcheck to verify that Nginx is responding correctly.

## 📌 Project Overview

This project focuses on understanding:

* Docker images and containers
* Docker Compose
* Port mapping
* Running Nginx inside a container
* Docker healthchecks
* Healthcheck intervals, timeouts, retries, and startup periods
* The difference between a running container and a healthy application

No custom Nginx configuration is required for this project. The goal is to understand Docker healthchecks using the default Nginx image.

## 📁 Project Structure

```text
Nginx-Healthcheck/
├── docker-compose.yml
└── README.md
```

## 🐳 Docker Compose Configuration

```yaml
services:
  nginx:
    image: nginx:latest
    container_name: nginx

    ports:
      - "4000:80"

    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 5s

    restart: unless-stopped
```

## 🔌 Port Mapping

The configuration uses:

```text
4000:80
```

The format is:

```text
HOST_PORT:CONTAINER_PORT
```

Therefore:

```text
localhost:4000 → Docker container port 80 → Nginx
```

Nginx listens on port `80` inside the container, while port `4000` is exposed on the host machine.

The application can be accessed at:

```text
http://localhost:4000
```

## ❤️ Docker Healthcheck

The healthcheck is:

```yaml
healthcheck:
  test: ["CMD", "wget", "--spider", "-q", "http://localhost"]
  interval: 10s
  timeout: 5s
  retries: 3
  start_period: 5s
```

Docker executes the following command inside the container:

```bash
wget --spider -q http://localhost
```

The command checks whether Nginx is responding to an HTTP request.

### Healthcheck Parameters

| Parameter      |      Value | Description                                              |
| -------------- | ---------: | -------------------------------------------------------- |
| `test`         | `wget ...` | Command Docker uses to test Nginx                        |
| `interval`     |      `10s` | Run the check every 10 seconds                           |
| `timeout`      |       `5s` | Maximum time allowed for one check                       |
| `retries`      |        `3` | Number of consecutive failures before becoming unhealthy |
| `start_period` |       `5s` | Initial startup grace period                             |

## 🚀 Running the Project

Start the container:

```bash
docker compose up -d
```

Check running containers:

```bash
docker ps
```

The container should eventually show:

```text
Up ... (healthy)
```

## 🌐 Test Nginx

Using `curl`:

```bash
curl http://localhost:4000
```

You should receive the default Nginx HTML response.

You can also open the following address in a browser:

```text
http://localhost:4000
```

## 🔍 Check Health Status

To display only the health status:

```bash
docker inspect nginx --format='{{.State.Health.Status}}'
```

Expected result:

```text
healthy
```

You can also inspect the complete healthcheck information:

```bash
docker inspect nginx
```

Look for:

```text
State → Health
```

## 🧪 Testing an Unhealthy Container

To understand how Docker healthchecks work, intentionally change the healthcheck URL:

```yaml
test: ["CMD", "wget", "--spider", "-q", "http://localhost:9999"]
```

Port `9999` is not being used by Nginx.

Recreate the container:

```bash
docker compose up -d
```

After several failed healthchecks, check:

```bash
docker ps
```

The container should eventually show:

```text
Up ... (unhealthy)
```

Check the status directly:

```bash
docker inspect nginx --format='{{.State.Health.Status}}'
```

Result:

```text
unhealthy
```

Restore the original healthcheck afterward.

## 🧠 Important Concept

A container being **running** does not necessarily mean the application inside it is functioning correctly.

For example:

```text
Container
   │
   ├── Running
   │
   └── Nginx
        │
        └── Not responding
```

Docker's healthcheck provides an additional way to determine whether the application is actually responding.

```text
Container State:  RUNNING
Application State: HEALTHY
```

These are two different concepts.

## 🔄 Restart Policy

The project uses:

```yaml
restart: unless-stopped
```

This allows Docker to restart the container if it stops unexpectedly.

Note that a healthcheck becoming `unhealthy` **does not itself restart the container**. Healthchecks report the application's health; restart policies handle container restarts.

## 🧹 Stopping the Project

Stop the container:

```bash
docker compose down
```

Check that it has been removed:

```bash
docker ps
```

## 🎯 Learning Goals

After completing this project, you should understand:

* What a Docker image is
* What a Docker container is
* How Docker Compose defines services
* How Docker port mapping works
* Why Nginx uses port `80` inside the container
* How to expose Nginx through host port `4000`
* How Docker executes a healthcheck
* How exit codes determine healthcheck success or failure
* What `healthy` and `unhealthy` mean
* The difference between container state and application health
* How `interval`, `timeout`, `retries`, and `start_period` work

## 🏁 Conclusion

This project demonstrates a basic but important Docker concept: **a container can be running without the application inside it necessarily being healthy**.

Docker healthchecks provide a mechanism for monitoring application availability from inside the container.

This provides a foundation for more advanced healthchecks in multi-container applications, backend services, databases, and eventually container orchestration platforms such as Kubernetes.
