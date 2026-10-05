# 🐳 Docker Projects

A hands-on collection of Docker and Docker Compose projects focused on **containerization, networking, persistent storage, multi-service applications, reverse proxies, databases, healthchecks, and observability**.

The repository documents my progression from individual containers toward more realistic multi-service DevOps environments.

---

## 🚀 Projects

| # | Project | Main Concepts | Status |
|---:|---|---|:---:|
| 01 | [Static Website + Nginx](./Static-Website-DockerNginx) | Dockerfile, Nginx, Port Mapping | ✅ |
| 02 | [Python Flask App](./Python-Flask-App) | Flask, Dockerfile, Application Containerization | ✅ |
| 03 | [Redis + Flask](./Redis-Flask-Docker) | Multi-Container Apps, Networking, Redis | ✅ |
| 04 | [PostgreSQL inside Docker](./PostgreSQL_inside_Docker) | PostgreSQL, Volumes, Persistence | ✅ |
| 05 | [Node.js Web Application](./Nodejs_Web_Application) | Node.js, Dockerfile | ✅ |
| 06 | [Nginx Reverse Proxy](./Nginx_Reverse_Proxy) | Reverse Proxy, Docker Networking | ✅ |
| 07 | [Prometheus + Grafana](./Grafana_Prometheus_Docker) | Metrics, Monitoring, Visualization | ✅ |
| 08 | [MySQL + phpMyAdmin](./MySQL_PHPmyAdmin_Docker) | MySQL, Volumes, Docker Compose | ✅ |
| 09 | [Docker Healthcheck + Nginx](./Docker-Healthcheck-Nginx) | Healthchecks, Service Reliability | ✅ |
| 10 | [Prometheus + Grafana + Alertmanager](./Grafana_Prometheus_Alertmanager) | Monitoring, Alerting | ✅ |
| 11 | [Prometheus + Grafana + cAdvisor](./Docker_Grafana_cAdvisor_Prometheus) | Container Monitoring, Metrics | ✅ |
| 12 | [Blackbox Exporter + Prometheus + Grafana](./Blackbox_Prometheus_Grafana) | Endpoint Monitoring, HTTP Probing | ✅ |
| 13 | [Flask + PostgreSQL Multi-Service App](./Flask_PostgreSQL_Docker) | Compose, PostgreSQL, Networking, Healthchecks | ✅ |

---

## 🧠 What This Repository Demonstrates

The projects cover practical experience with:

- Building custom Docker images
- Writing Dockerfiles
- Container lifecycle management
- Port mapping
- Persistent volumes
- Docker networking and internal DNS
- Docker Compose
- Multi-container application architectures
- Reverse proxy configuration with Nginx
- PostgreSQL, MySQL, and Redis containers
- Environment-based configuration
- Container healthchecks
- Service dependencies
- Metrics collection
- Monitoring and alerting
- Container and endpoint observability

---

## 🏗️ Learning Progression

```text
Docker Fundamentals
        ↓
Dockerfiles & Images
        ↓
Containers & Port Mapping
        ↓
Volumes & Persistence
        ↓
Docker Networking
        ↓
Docker Compose
        ↓
Multi-Service Applications
        ↓
Reverse Proxies
        ↓
Databases
        ↓
Healthchecks
        ↓
Monitoring & Metrics
        ↓
Alerting
        ↓
Container Observability
        ↓
Production-Oriented Containers
```

---

## 🛠️ Technologies

### Containers
- Docker
- Docker Compose
- Dockerfiles

### Applications & Infrastructure
- Nginx
- Python
- Flask
- Node.js

### Data Services
- PostgreSQL
- MySQL
- Redis
- phpMyAdmin

### Monitoring & Observability
- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- cAdvisor
- Blackbox Exporter

### Environment
- Linux
- Git
- GitHub

---

## 🧩 Example Architecture

Several projects move beyond isolated containers and use multi-service architectures such as:

```text
             Client
               │
               ▼
             Nginx
               │
               ▼
          Application
           │       │
           ▼       ▼
      PostgreSQL  Redis
```

Monitoring projects introduce architectures such as:

```text
Application / Container / Endpoint
                │
                ▼
        Exporter / Metrics
                │
                ▼
           Prometheus
                │
         ┌──────┴──────┐
         ▼             ▼
      Grafana      Alertmanager
```

---

## 🔍 Engineering Approach

For each project, I aim to follow a practical workflow:

```text
Understand the requirement
        ↓
Design the container architecture
        ↓
Write Dockerfile / Compose configuration
        ↓
Build and start the environment
        ↓
Verify networking and service communication
        ↓
Test persistence and health
        ↓
Inspect logs and troubleshoot failures
        ↓
Document the implementation
```

---

## 📌 Featured Areas

### Multi-Service Applications

Projects demonstrate application-to-service communication using Docker's internal networking and service discovery.

Examples include:

```text
Flask → Redis
```

and:

```text
Flask → PostgreSQL
```

---

### Persistent Storage

Database projects use Docker volumes to ensure data survives container recreation.

```text
Container Lifecycle
        ≠
Persistent Data Lifecycle
```

---

### Reverse Proxying

The Nginx reverse proxy project demonstrates traffic routing between clients and containerized applications.

```text
Client
   ↓
 Nginx
   ↓
Application
```

---

### Healthchecks

Healthcheck projects verify whether a containerized service is actually operational rather than merely running.

---

### Monitoring & Observability

Monitoring projects progressively introduce:

```text
Metrics
   ↓
Prometheus
   ↓
Grafana
   ↓
Alerting
   ↓
Container Monitoring
   ↓
Endpoint Monitoring
```

---

## 🔮 Next Steps

Future Docker projects will focus on:

- Resource limits and container reliability
- Restart policies
- Multi-stage builds
- Image optimization
- Non-root containers
- Container security hardening
- Secrets management
- Image scanning
- GitHub Actions
- Automated Docker builds
- Container registries
- CI/CD workflows
- Production-style Compose deployments

---

## 📌 Repository Status

🟢 **Actively maintained**

This repository is part of my hands-on DevOps portfolio and continues to evolve as I move toward more advanced container automation, CI/CD, infrastructure, and cloud-native technologies.
