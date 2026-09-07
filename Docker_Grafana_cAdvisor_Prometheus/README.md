# Docker Grafana + cAdvisor + Prometheus

A container monitoring project built with **Docker Compose, cAdvisor, Prometheus, Grafana, and Redis**.

The project demonstrates how to collect Docker container metrics with cAdvisor, scrape those metrics using Prometheus, and visualize them with Grafana.

## Architecture

```text
                    Docker Host
                         │
                         │
                ┌────────▼────────┐
                │     cAdvisor    │
                │ Container Metrics│
                └────────┬────────┘
                         │
                    :8080│
                         ▼
                ┌────────────────┐
                │   Prometheus   │
                │ Metrics Storage│
                └────────┬───────┘
                         │
                    :9090│
                         ▼
                ┌────────────────┐
                │    Grafana     │
                │ Visualization  │
                └────────────────┘

                ┌────────────────┐
                │     Redis      │
                │   Container    │
                └────────────────┘
```

## Technologies

* Docker
* Docker Compose
* Prometheus
* Grafana
* cAdvisor
* Redis
* YAML

## Project Structure

```text
Docker_Grafana_cAdvisor_Prometheus/
├── docker-compose.yml
├── prometheus.yml
└── README.md
```

## Services

### Prometheus

Prometheus collects and stores metrics exposed by cAdvisor.

Port:

```text
9090
```

Access:

```text
http://localhost:9090
```

### cAdvisor

cAdvisor collects resource and performance information from running Docker containers.

Port:

```text
8080
```

Access:

```text
http://localhost:8080
```

The project uses the official cAdvisor image:

```text
ghcr.io/google/cadvisor:0.60.5
```

cAdvisor is given read access to several host directories so that it can collect container-level metrics.

### Redis

Redis is included as a monitored Docker workload.

Port:

```text
6379
```

The purpose of Redis in this project is to provide an additional running container whose resource usage can be observed through cAdvisor.

### Grafana

Grafana provides dashboards for visualizing the metrics collected by Prometheus.

Port:

```text
3000
```

Access:

```text
http://localhost:3000
```

## Prometheus Configuration

Prometheus is configured to scrape cAdvisor every 5 seconds:

```yaml
scrape_configs:
  - job_name: cadvisor
    scrape_interval: 5s
    static_configs:
      - targets:
          - cadvisor:8080
```

The important part is:

```text
cadvisor:8080
```

Instead of using `localhost`, Prometheus communicates with the cAdvisor container using its Docker service name.

Docker Compose provides internal DNS resolution between services on the Compose network.

## Docker Compose

The stack is defined in `docker-compose.yml`.

Start the complete monitoring stack with:

```bash
sudo docker-compose up -d
```

Or, with modern Docker Compose:

```bash
sudo docker compose up -d
```

Check the running containers:

```bash
sudo docker compose ps
```

Expected services:

```text
prometheus
cadvisor
redis
grafana
```

## Accessing the Services

After starting the stack:

| Service    | URL                   | Port |
| ---------- | --------------------- | ---: |
| Prometheus | http://localhost:9090 | 9090 |
| cAdvisor   | http://localhost:8080 | 8080 |
| Grafana    | http://localhost:3000 | 3000 |
| Redis      | localhost             | 6379 |

## Configure Grafana

After opening Grafana:

```text
http://localhost:3000
```

Add Prometheus as a data source.

Use the following URL from inside the Grafana container:

```text
http://prometheus:9090
```

Do **not** use:

```text
http://localhost:9090
```

because `localhost` inside the Grafana container refers to the Grafana container itself.

After adding Prometheus, Grafana can query the metrics collected from cAdvisor.

## Example Metrics

cAdvisor exposes metrics such as:

* CPU usage
* Memory usage
* Network traffic
* Filesystem usage
* Container uptime
* Container resource consumption

These metrics can be queried through Prometheus and visualized in Grafana.

## Useful Commands

Start the stack:

```bash
sudo docker compose up -d
```

Stop the stack:

```bash
sudo docker compose down
```

View running containers:

```bash
sudo docker compose ps
```

View logs:

```bash
sudo docker compose logs
```

View logs for a specific service:

```bash
sudo docker compose logs prometheus
```

```bash
sudo docker compose logs cadvisor
```

```bash
sudo docker compose logs grafana
```

Follow logs:

```bash
sudo docker compose logs -f
```

Pull updated images:

```bash
sudo docker compose pull
```

## Verification

Check that cAdvisor is exposing metrics:

```bash
curl http://localhost:8080/metrics
```

Check the Prometheus targets:

```text
http://localhost:9090/targets
```

The cAdvisor target should show as:

```text
UP
```

You can also check Prometheus directly:

```text
http://localhost:9090
```

and search for cAdvisor metrics.

## Key Docker Concepts Practiced

This project demonstrates:

* Docker Compose
* Multi-container applications
* Container networking
* Service-name DNS resolution
* Port publishing
* Bind mounts
* Host filesystem access
* Container monitoring
* Metrics collection
* Prometheus scraping
* Grafana visualization
* Docker resource monitoring

## Important Notes

The cAdvisor container requires access to host-level directories:

```yaml
volumes:
  - /:/rootfs:ro
  - /var/run:/var/run:rw
  - /sys:/sys:ro
  - /var/lib/docker/:/var/lib/docker:ro
```

These mounts allow cAdvisor to inspect Docker and host resources.

Because these mounts provide significant visibility into the host system, this configuration should be treated carefully in production environments.

## Troubleshooting

### cAdvisor image cannot be pulled

Use the current cAdvisor image:

```yaml
image: ghcr.io/google/cadvisor:0.60.5
```

Older tutorials may use:

```text
gcr.io/google-containers/cadvisor
```

or:

```text
gcr.io/cadvisor/cadvisor
```

These references may no longer work.

### Prometheus target is DOWN

Check the Prometheus logs:

```bash
sudo docker compose logs prometheus
```

Then verify that cAdvisor is running:

```bash
sudo docker compose ps
```

You can also test:

```bash
curl http://localhost:8080/metrics
```

### Grafana cannot connect to Prometheus

When configuring the Grafana data source, use:

```text
http://prometheus:9090
```

rather than:

```text
http://localhost:9090
```

## Learning Outcome

After completing this project, I understand how to build a Docker-based monitoring stack where:

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

This project provides a foundation for more advanced Docker observability projects involving **centralized logging, alerting, container health monitoring, and production monitoring stacks**.

## Author

**Amir Ashofteh**

Docker Projects
2026

