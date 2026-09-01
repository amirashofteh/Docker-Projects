# 🐳 Docker Projects

A hands-on collection of Docker projects focused on building practical skills in **containerization, Docker Compose, networking, persistent storage, web applications, databases, reverse proxies, and monitoring**.

This repository is built as a practical learning portfolio: each project introduces a Docker concept and gradually increases in complexity, moving from individual containers to multi-service applications and monitoring stacks.

---

## 🎯 Repository Goals

The main goal of this repository is to develop practical Docker and DevOps skills through implementation rather than theory alone.

The projects focus on:

* Docker images and containers
* Dockerfiles
* Port mapping
* Docker volumes
* Docker networking
* Docker Compose
* Multi-container applications
* Environment configuration
* Nginx reverse proxies
* Web applications
* Database containers
* Redis
* PostgreSQL
* MySQL
* Prometheus
* Grafana
* Alertmanager
* cAdvisor
* Blackbox Exporter
* Healthchecks
* Service-to-service communication

---

## 📂 Projects

|  # | Project                                                                   | Main Concepts                                     | Status |
| -: | ------------------------------------------------------------------------- | ------------------------------------------------- | :----: |
| 01 | [Static Website + Nginx](./Static-Website-DockerNginx)                    | Dockerfile, Nginx, Port Mapping                   |    ✅   |
| 02 | [Python Flask App](./Python-Flask-App)                                    | Python, Flask, Dockerfile                         |    ✅   |
| 03 | [Redis + Flask](./Redis-Flask-Docker)                                     | Multi-Container Apps, Networking, Redis           |    ✅   |
| 04 | [PostgreSQL inside Docker](./PostgreSQL_inside_Docker)                    | PostgreSQL, Volumes, Persistence                  |    ✅   |
| 05 | [Node.js Web Application](./Nodejs_Web_Application)                       | Node.js, Dockerfile, Application Containerization |    ✅   |
| 06 | [Nginx Reverse Proxy](./Nginx_Reverse_Proxy)                              | Reverse Proxy, Networking                         |    ✅   |
| 07 | [Prometheus + Grafana](./Grafana_Prometheus_Docker)                       | Prometheus, Grafana, Metrics                      |    ✅   |
| 08 | [MySQL + phpMyAdmin](./MySQL_PHPmyAdmin_Docker)                           | MySQL, phpMyAdmin, Volumes, Compose               |    ✅   |
| 09 | [Docker Healthcheck + Nginx](./Docker-Healthcheck-Nginx)                  | Healthchecks, Container Health                    |    ✅   |
| 10 | [Prometheus + Grafana + Alertmanager](./Grafana_Prometheus_Alertmanager)  | Alerting, Prometheus, Grafana                     |    ✅   |
| 11 | [Prometheus + Grafana + cAdvisor](./Docker_Grafana_cAdvisor_Prometheus)   | Container Monitoring, cAdvisor                    |    ✅   |
| 12 | [Blackbox Exporter + Prometheus + Grafana](./Blackbox_Prometheus_Grafana) | External Monitoring, HTTP/HTTPS Probing           |    ✅   |
| 13 | [Flask + PostgreSQL Multi-Service](./Flask_PostgreSQL_Docker)             | Compose, Networking, PostgreSQL, Healthchecks     |    ✅   |

> More projects will be added as the repository progresses toward advanced Docker and DevOps topics.

---

## 🏗️ Learning Progression

The projects are intentionally organized from fundamental Docker concepts toward more complex infrastructure:

```text
Docker Basics
      ↓
Dockerfiles
      ↓
Images & Containers
      ↓
Port Mapping
      ↓
Volumes
      ↓
Docker Networking
      ↓
Docker Compose
      ↓
Multi-Container Applications
      ↓
Nginx Reverse Proxy
      ↓
Databases & Persistence
      ↓
Healthchecks
      ↓
Prometheus & Grafana
      ↓
Alerting
      ↓
Container Monitoring
      ↓
External Service Monitoring
      ↓
Advanced Docker
      ↓
CI/CD
      ↓
Infrastructure & DevOps
```

---

# 🐳 Docker Fundamentals

## Images

Docker images provide the templates used to create containers.

Example:

```bash
docker build -t my-app .
```

Useful commands:

```bash
docker images
docker image ls
```

---

## Containers

Containers run applications in isolated environments.

Example:

```bash
docker run -d -p 8080:80 my-app
```

Useful commands:

```bash
docker ps
docker ps -a
docker logs container-name
docker exec -it container-name /bin/sh
```

---

## Dockerfiles

Projects in this repository use Dockerfiles to define reproducible application environments.

Common Dockerfile instructions practiced include:

```text
FROM
WORKDIR
COPY
RUN
EXPOSE
CMD
ENTRYPOINT
```

Example:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

# 🔌 Port Mapping

Docker port mapping connects container services to the host machine.

```text
Host Port → Container Port
```

Example:

```text
localhost:8080 → container:80
```

Compose example:

```yaml
ports:
  - "8080:80"
```

Port mapping is used throughout the projects to expose web applications, Grafana, Prometheus, and other services.

---

# 💾 Docker Volumes

Docker volumes provide persistent storage independently of a container's lifecycle.

Example:

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
```

This allows database data to survive container recreation.

The database projects use volumes to demonstrate the difference between:

```text
Container
    ≠
Persistent Data
```

---

# 🌐 Docker Networking

Docker containers can communicate through Docker networks.

With Docker Compose, services can communicate using their service names.

Example:

```text
Flask
  │
  │ postgres:5432
  ▼
PostgreSQL
```

Inside the Flask container:

```text
postgres
```

resolves to the PostgreSQL service through Docker's internal DNS.

This approach avoids relying on hard-coded container IP addresses.

---

# 🧩 Docker Compose

Docker Compose allows multiple related services to be defined and operated together.

Example:

```bash
docker compose up -d
```

Stop the services:

```bash
docker compose down
```

View service status:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs
```

Follow logs:

```bash
docker compose logs -f
```

The Compose projects in this repository demonstrate multi-service architectures such as:

```text
Flask
  ↓
Redis
```

```text
Flask
  ↓
PostgreSQL
```

```text
Nginx
  ↓
Application
```

and:

```text
Exporter
  ↓
Prometheus
  ↓
Grafana
```

---

# 🔀 Multi-Container Applications

Several projects use multiple containers working together as independent services.

A typical architecture is:

```text
                    Client
                       │
                       ▼
                    Nginx
                       │
                       ▼
                  Application
                    │     │
                    ▼     ▼
               PostgreSQL Redis
```

Each service has its own responsibility while Docker networking allows them to communicate.

This approach introduces practical experience with:

* Service discovery
* Internal DNS
* Container networking
* Service dependencies
* Database connections
* Application/database separation

---

# 🌐 Nginx Reverse Proxy

The Nginx reverse proxy project demonstrates how Nginx can sit in front of an application:

```text
Client
   │
   ▼
 Nginx
   │
   ▼
Application
```

The project provides hands-on experience with:

* Reverse proxy configuration
* Docker networking
* Nginx configuration files
* Internal service communication

Nginx configuration is managed through:

```text
/etc/nginx/conf.d/
```

---

# 🗄️ Database Containers

The repository includes multiple database-based projects.

### PostgreSQL

```text
PostgreSQL
    │
    ▼
Docker Volume
```

The PostgreSQL project focuses on:

* Database containerization
* Persistent storage
* Initialization scripts
* Setup and cleanup automation
* Persistence testing

### MySQL + phpMyAdmin

```text
phpMyAdmin
      │
      ▼
    MySQL
      │
      ▼
 Docker Volume
```

This project introduces database administration through a containerized environment.

---

# ❤️ Container Healthchecks

The healthcheck project demonstrates how Docker can determine whether a service is actually healthy.

Example:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 3
```

Healthchecks are useful for:

* Detecting service failures
* Monitoring application availability
* Coordinating dependent services
* Building more reliable Compose environments

---

# 📊 Monitoring

The repository contains several monitoring projects built around the Prometheus ecosystem.

## Prometheus + Grafana

```text
Node Exporter
      │
      ▼
Prometheus
      │
      ▼
Grafana
```

### Prometheus

Prometheus collects and stores time-series metrics.

### Grafana

Grafana visualizes metrics through dashboards.

### Node Exporter

Node Exporter provides system-level metrics that can be collected by Prometheus.

---

# 🚨 Alertmanager

The Alertmanager project extends the Prometheus monitoring stack with alerting.

```text
Target
  │
  ▼
Prometheus
  │
  ▼
Alert Rules
  │
  ▼
Alertmanager
```

This introduces concepts such as:

* Prometheus alert rules
* Alert routing
* Alert handling
* Monitoring failures

---

# 📦 cAdvisor Monitoring

cAdvisor provides container-level metrics.

Architecture:

```text
Docker Containers
       │
       ▼
    cAdvisor
       │
       ▼
   Prometheus
       │
       ▼
    Grafana
```

This allows container resource usage and performance to be monitored through Prometheus and Grafana.

---

# 🌍 Blackbox Monitoring

The Blackbox project introduces external service monitoring.

Architecture:

```text
Target Website
      │
      ▼
Blackbox Exporter
      │
      ▼
Prometheus
      │
      ▼
Grafana
```

Blackbox Exporter can be used to probe endpoints and expose metrics such as:

* Probe success
* HTTP status codes
* Probe duration
* DNS timing
* TLS timing
* SSL certificate information

This differs from Node Exporter and cAdvisor because the focus is on **service availability and reachability** rather than host or container resource metrics.

---

# 🔗 Flask + PostgreSQL Multi-Service Application

The Flask + PostgreSQL project demonstrates a complete multi-container application:

```text
Client
  │
  ▼
Flask
  │
  │ postgres:5432
  ▼
PostgreSQL
```

The project demonstrates:

* Flask application containerization
* PostgreSQL containerization
* Docker Compose
* Internal Docker networking
* Environment variables
* Healthchecks
* Service dependencies
* Persistent database storage
* Container-to-container communication

---

# 🛠️ Technologies

The technologies currently used in this repository include:

* Docker
* Docker Compose
* Dockerfiles
* Linux
* Git
* GitHub
* Nginx
* Python
* Flask
* Node.js
* Redis
* PostgreSQL
* MySQL
* phpMyAdmin
* Prometheus
* Grafana
* Node Exporter
* cAdvisor
* Alertmanager
* Blackbox Exporter

---

# 🚀 Common Docker Commands

Check Docker:

```bash
docker --version
```

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

List images:

```bash
docker images
```

Build an image:

```bash
docker build -t image-name .
```

Run a container:

```bash
docker run -d image-name
```

View container logs:

```bash
docker logs container-name
```

Open a shell inside a container:

```bash
docker exec -it container-name /bin/sh
```

Stop a container:

```bash
docker stop container-name
```

Remove a container:

```bash
docker rm container-name
```

---

# 🐳 Common Docker Compose Commands

Start services:

```bash
docker compose up -d
```

Build and start services:

```bash
docker compose up -d --build
```

View services:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs
```

Follow logs:

```bash
docker compose logs -f
```

Stop services:

```bash
docker compose stop
```

Stop and remove containers:

```bash
docker compose down
```

Stop and remove containers and volumes:

```bash
docker compose down -v
```

> Be careful with `docker compose down -v` when databases are involved because removing volumes can delete persistent database data.

---

# 📚 What I Am Learning

Through these projects, I am developing practical experience with:

* Containerization
* Application deployment
* Docker image creation
* Docker networking
* Persistent storage
* Multi-container architectures
* Database deployment
* Reverse proxies
* Service health monitoring
* Infrastructure monitoring
* Metrics collection
* Alerting
* Git and GitHub workflows
* DevOps practices

The goal is to progress from individual Docker containers toward **production-style containerized infrastructure, automation, monitoring, and CI/CD**.

---

# 🔮 Next Steps

The repository will continue moving toward more advanced Docker and DevOps topics.

Planned areas include:

```text
Docker Reliability
       ↓
Resource Management
       ↓
Image Optimization
       ↓
Multi-Stage Builds
       ↓
Container Security
       ↓
Secrets Management
       ↓
Docker CI/CD
       ↓
Container Registry
       ↓
Advanced Monitoring
       ↓
Docker Swarm
       ↓
Kubernetes
```

Potential future projects include:

* Container auto-recovery
* Restart policies
* Resource limits
* Logging and log rotation
* Multi-stage Docker builds
* Image size optimization
* Non-root containers
* Docker secrets
* Container security hardening
* Docker image scanning
* GitHub Actions
* Automated Docker builds
* Container registry workflows
* Production-style Compose deployments
* Advanced Prometheus monitoring
* Kubernetes deployments

---

# 📈 Repository Philosophy

The purpose of this repository is not simply to collect Docker examples.

Each project is intended to answer a practical question:

```text
How does Docker work?
        ↓
How do containers communicate?
        ↓
How do I persist data?
        ↓
How do I deploy multiple services?
        ↓
How do I monitor them?
        ↓
How do I detect failures?
        ↓
How do I secure them?
        ↓
How do I automate them?
        ↓
How do I operate them in production?
```

Each project is documented separately with its own README, configuration, architecture, and usage instructions.

---

## 📌 Repository Status

**Active learning and development repository**

Projects are continuously added and improved as I progress through Docker, monitoring, automation, and DevOps topics.

---

## 👨‍💻 Author

**Amir Ashofteh**

Hands-on learning portfolio focused on:

```text
Linux
Docker
Networking
Monitoring
Automation
DevOps
```
