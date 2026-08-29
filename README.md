# 🐳 Docker Projects

A collection of hands-on Docker projects created to build practical experience with **containerization, Docker Compose, networking, persistent storage, reverse proxies, databases, web applications, and monitoring**.

The projects progress from basic Docker concepts to more advanced multi-container environments used in real-world DevOps workflows.

## 🎯 Purpose

The goal of this repository is to develop practical Docker and DevOps skills by building and documenting real projects instead of relying only on theoretical learning.

The projects cover:

* Docker fundamentals
* Dockerfiles
* Docker images and containers
* Port mapping
* Docker volumes
* Docker networking
* Docker Compose
* Multi-container applications
* Nginx reverse proxy
* Web applications
* Databases
* Redis
* Monitoring
* Prometheus
* Grafana
* Node Exporter
* Containerized development environments

---

## 📂 Projects

| #  | Project                 | Main Concepts                           |
| -- | ----------------------- | --------------------------------------- |
| 01 | Static Website + Nginx  | Dockerfile, Nginx, Port Mapping         |
| 02 | Python Flask App        | Python, Flask, Dockerfile               |
| 03 | Redis + Flask           | Multi-container Application, Networking |
| 04 | PostgreSQL              | Database Container, Volumes             |
| 05 | Node.js Web Application | Node.js, Dockerfile                     |
| 06 | Nginx Reverse Proxy     | Reverse Proxy, Docker Networking        |
| 07 | Prometheus + Grafana    | Monitoring, Metrics, Docker Compose     |
| 08 | MySQL + phpMyAdmin      | MySQL, phpMyAdmin, Volumes, Compose     |

> The repository is continuously updated as new Docker and DevOps projects are completed.

---

# 🏗️ Concepts Covered

## Docker Images

Understanding how Docker images are created and used as templates for containers.

Example:

```bash
docker build -t my-app .
```

## Containers

Running applications inside isolated containers.

```bash
docker run -d -p 8080:80 my-app
```

## Dockerfiles

Projects use Dockerfiles to define application environments and build reproducible images.

Common instructions practiced include:

```dockerfile
FROM
WORKDIR
COPY
RUN
EXPOSE
CMD
ENTRYPOINT
```

## Port Mapping

Connecting container services to the host machine.

```text
Host Port → Container Port
```

Example:

```text
localhost:8080 → container:80
```

## Docker Volumes

Persistent storage for applications and databases.

Example:

```yaml
volumes:
  - mysql_data:/var/lib/mysql
```

Volumes allow data to survive container recreation.

## Docker Networking

Containers communicate with each other through Docker networks.

For example:

```text
phpMyAdmin
     │
     ▼
   mysql
```

Docker Compose service names can be used for internal communication.

## Docker Compose

Multiple related services can be managed using a single Compose configuration.

Example:

```bash
docker compose up -d
```

and:

```bash
docker compose down
```

---

# 🔀 Multi-Container Architecture

Several projects use multiple containers working together.

A typical architecture looks like:

```text
                    Client
                      │
                      ▼
                   Nginx
                      │
                      ▼
                Application
                      │
              ┌───────┴───────┐
              ▼               ▼
           Database          Redis
```

This provides practical experience with service-to-service communication and container networking.

---

# 🌐 Nginx Reverse Proxy

The Nginx project demonstrates how a reverse proxy can sit in front of an application.

```text
Client
  │
  ▼
Nginx
  │
  ▼
Application
```

The Nginx configuration is managed inside:

```text
/etc/nginx/conf.d/
```

This project also provides practical experience with entering containers and modifying their configuration.

---

# 📊 Monitoring Stack

The monitoring project uses:

```text
Node Exporter
      │
      ▼
Prometheus
      │
      ▼
Grafana
```

### Node Exporter

Collects system-level metrics.

### Prometheus

Collects and stores metrics.

### Grafana

Provides dashboards for visualizing the collected metrics.

This project introduces containerized infrastructure monitoring and provides a foundation for further DevOps monitoring work.

---

# 🗄️ Database Containers

The repository includes containerized database environments such as:

* PostgreSQL
* MySQL

The MySQL + phpMyAdmin project uses:

```text
phpMyAdmin
     │
     ▼
 MySQL 8.0
     │
     ▼
Docker Volume
```

Database persistence is implemented using Docker named volumes.

---

# 🛠️ Technologies

* Docker
* Docker Compose
* Dockerfiles
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
* Linux
* Git
* GitHub

---

# 🚀 Basic Docker Commands

Check Docker version:

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

Stop a container:

```bash
docker stop container-name
```

Remove a container:

```bash
docker rm container-name
```

Remove an image:

```bash
docker rmi image-name
```

---

# 🐳 Docker Compose Commands

Start services:

```bash
docker compose up -d
```

View running services:

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

> Be careful with `docker compose down -v` when databases are involved because it removes the associated Docker volumes and stored data.

---

# 📚 Learning Progression

The projects are designed to progressively increase in complexity:

```text
Docker Basics
      ↓
Dockerfiles
      ↓
Containers
      ↓
Port Mapping
      ↓
Volumes
      ↓
Networking
      ↓
Docker Compose
      ↓
Multi-Container Applications
      ↓
Nginx Reverse Proxy
      ↓
Databases
      ↓
Monitoring
      ↓
CI/CD
```

---

# 🔮 Future Projects

Planned improvements and future projects include:

* GitHub Actions CI/CD
* Automated Docker image builds
* Docker image publishing
* Docker health checks
* Multi-stage Docker builds
* Docker security
* Container resource management
* Advanced monitoring
* Alerting
* Kubernetes deployments

---

# 🎓 What I Am Learning

Through these projects, I am developing practical experience with:

* Containerization
* Application deployment
* Linux administration
* Docker networking
* Persistent storage
* Service orchestration
* Reverse proxies
* Database deployment
* Infrastructure monitoring
* Git/GitHub workflows
* DevOps practices

The long-term goal is to progress from individual Docker projects toward **automated CI/CD pipelines and production-style containerized infrastructure**.

---

## 📌 Repository Status

This repository is actively maintained and expanded as I continue developing my Docker and DevOps skills.

Each project is documented separately with its own README containing setup instructions, architecture, configuration, and usage information.
