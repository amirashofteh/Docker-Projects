# Grafana + Prometheus + Node Exporter Monitoring Stack

A containerized monitoring stack built with **Docker Compose**, **Prometheus**, **Grafana**, and **Node Exporter**.

This project collects system metrics using Node Exporter, stores and queries the metrics with Prometheus, and visualizes them through Grafana.

The project was built as a practical introduction to **containerized monitoring and observability**.

## Architecture

```text
                    ┌─────────────────────┐
                    │     Node Exporter   │
                    │      :9100          │
                    │                     │
                    │ System Metrics      │
                    └──────────┬──────────┘
                               │
                               │ Scrape
                               ▼
                    ┌─────────────────────┐
                    │     Prometheus      │
                    │       :9090         │
                    │                     │
                    │ Metrics Collection  │
                    │ & Time-Series DB    │
                    └──────────┬──────────┘
                               │
                               │ Query
                               ▼
                    ┌─────────────────────┐
                    │       Grafana       │
                    │       :3000         │
                    │                     │
                    │ Dashboards &        │
                    │ Visualization       │
                    └─────────────────────┘
```

All three services communicate through a dedicated Docker bridge network called `monitoring`.

## Technologies Used

* Docker
* Docker Compose
* Prometheus
* Grafana OSS
* Node Exporter
* YAML
* Docker Volumes
* Docker Bridge Networks

## Project Structure

```text
Grafana_Prometheus_Docker/
├── docker-compose.yaml
├── prometheus.yml
└── README.md
```

## Services

### Node Exporter

Node Exporter collects hardware and operating-system-level metrics and exposes them on port `9100`.

Examples of metrics include:

* CPU usage
* Memory usage
* Disk usage
* Filesystem statistics
* Network statistics
* System load
* Other Linux system metrics

The container uses:

```yaml
command:
  - '--path.rootfs=/host'
```

to allow Node Exporter to access the host filesystem.

Node Exporter is available at:

```text
http://localhost:9100
```

## Prometheus

Prometheus periodically scrapes metrics from Node Exporter and stores them in its time-series database.

The Prometheus configuration is defined in:

```text
prometheus.yml
```

The scrape interval is configured to:

```yaml
global:
  scrape_interval: 10s
```

Prometheus monitors two targets:

```yaml
- job_name: "prometheus"
  static_configs:
    - targets: ["prometheus:9090"]

- job_name: "node-exporter"
  static_configs:
    - targets: ["node-exporter:9100"]
```

Prometheus is available at:

```text
http://localhost:9090
```

## Grafana

Grafana is used to visualize the metrics collected by Prometheus.

Grafana is available at:

```text
http://localhost:3000
```

Default credentials configured in this project:

```text
Username: admin
Password: password
```

> For a production deployment, change the default password and avoid storing credentials directly in `docker-compose.yaml`.

## Grafana Dashboard

This project uses the popular **Node Exporter Full** Grafana dashboard.

Dashboard ID:

```text
1860
```

The dashboard provides a detailed overview of system metrics collected by Node Exporter, including CPU, memory, disk, filesystem, network, and system performance information.

To import it:

1. Open Grafana.
2. Log in with the configured credentials.
3. Go to **Dashboards**.
4. Select **Import**.
5. Enter:

```text
1860
```

6. Select your Prometheus data source.
7. Import the dashboard.

## Persistent Storage

The project uses two Docker named volumes:

```yaml
volumes:
  prometheus_data: {}
  grafana_data: {}
```

These volumes are mounted to:

```text
prometheus_data -> /prometheus
grafana_data    -> /var/lib/grafana
```

This allows Prometheus metrics and Grafana configuration/data to survive container recreation.

## Docker Network

A dedicated bridge network is created:

```yaml
networks:
  monitoring:
    driver: bridge
```

All three containers are connected to this network.

Because they share the same Docker network, services can communicate using their container/service names.

For example:

```text
prometheus:9090
node-exporter:9100
```

instead of relying on localhost between containers.

## Getting Started

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd Grafana_Prometheus_Docker
```

### 2. Verify the Files

Make sure the directory contains:

```bash
ls
```

Expected output:

```text
docker-compose.yaml
prometheus.yml
README.md
```

### 3. Start the Stack

Run:

```bash
docker compose up -d
```

This will download the required images and start:

* Node Exporter
* Prometheus
* Grafana

### 4. Check Running Containers

```bash
docker compose ps
```

You should see the three services running.

You can also use:

```bash
docker ps
```

### 5. Check Logs

To view all logs:

```bash
docker compose logs
```

To view logs for a specific service:

```bash
docker compose logs prometheus
```

```bash
docker compose logs grafana
```

```bash
docker compose logs node-exporter
```

## Access the Services

After starting the containers, open:

### Grafana

```text
http://localhost:3000
```

### Prometheus

```text
http://localhost:9090
```

### Node Exporter

```text
http://localhost:9100
```

## Configure Prometheus as Grafana Data Source

After logging into Grafana:

1. Open **Connections**.
2. Select **Data Sources**.
3. Add **Prometheus**.
4. Set the Prometheus URL to:

```text
http://prometheus:9090
```

5. Click **Save & Test**.

Because Grafana and Prometheus are running inside the same Docker network, Grafana can reach Prometheus using the service name `prometheus`.

## Verify Prometheus Targets

Open:

```text
http://localhost:9090/targets
```

The following targets should be available:

```text
prometheus:9090
node-exporter:9100
```

Both targets should eventually show as:

```text
UP
```

If `node-exporter` is `UP`, Prometheus is successfully collecting system metrics from Node Exporter.

## Useful Commands

Start the containers:

```bash
docker compose up -d
```

Stop the containers:

```bash
docker compose down
```

Restart the stack:

```bash
docker compose restart
```

View container status:

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

Stop and remove containers:

```bash
docker compose down
```

Stop containers and remove persistent volumes:

```bash
docker compose down -v
```

> Be careful with `docker compose down -v`. Removing the volumes deletes the stored Prometheus and Grafana data.

## Testing the Monitoring Stack

A basic verification workflow is:

```text
1. Start Docker Compose
        ↓
2. Verify containers are running
        ↓
3. Open Node Exporter
        ↓
4. Verify Prometheus targets
        ↓
5. Configure Grafana
        ↓
6. Import Dashboard 1860
        ↓
7. Verify system metrics
```

You can also check Node Exporter metrics directly:

```bash
curl http://localhost:9100/metrics
```

Prometheus can be tested by opening:

```text
http://localhost:9090
```

and querying metrics such as:

```text
up
```

or:

```text
node_cpu_seconds_total
```

## Troubleshooting

### Containers are not running

Check:

```bash
docker compose ps
```

Then inspect the logs:

```bash
docker compose logs
```

### Prometheus cannot scrape Node Exporter

Check the Prometheus targets page:

```text
http://localhost:9090/targets
```

Make sure the target is:

```text
node-exporter:9100
```

and not:

```text
localhost:9100
```

Inside the Docker network, `localhost` refers to the Prometheus container itself.

### Grafana cannot connect to Prometheus

The Grafana data source URL should be:

```text
http://prometheus:9090
```

not:

```text
http://localhost:9090
```

because Grafana is running inside its own container.

### Port already in use

If one of the ports is already being used, check:

```bash
sudo ss -tulpn
```

The default ports used by this project are:

```text
3000  -> Grafana
9090  -> Prometheus
9100  -> Node Exporter
```

## What I Learned

This project demonstrates several practical DevOps and monitoring concepts:

* Creating multi-container environments with Docker Compose
* Writing Docker Compose YAML configurations
* Creating and using Docker networks
* Using Docker named volumes for persistent data
* Running Prometheus in a container
* Configuring Prometheus scrape targets
* Collecting Linux system metrics with Node Exporter
* Connecting Grafana to Prometheus
* Importing and using Grafana dashboards
* Troubleshooting container networking
* Understanding service-name-based communication in Docker
* Basic monitoring and observability concepts

## Future Improvements

Possible improvements for this project include:

* Replace hard-coded Grafana credentials with environment variables or Docker secrets.
* Add alerting rules to Prometheus.
* Configure Grafana alerting.
* Add Alertmanager.
* Add cAdvisor for Docker container metrics.
* Monitor multiple hosts using Node Exporter.
* Create custom Grafana dashboards.
* Add health checks to the Docker Compose services.
* Pin Docker image versions instead of using `latest`.
* Add automated provisioning for Grafana data sources and dashboards.
* Add HTTPS/reverse proxy support using Nginx or Traefik.

## Project Goal

The goal of this project is to build a practical monitoring stack and understand how **metrics collection, time-series storage, and visualization** work together in a containerized environment.

```text
Node Exporter
     │
     │ Metrics
     ▼
Prometheus
     │
     │ Queries
     ▼
Grafana
     │
     ▼
Monitoring Dashboard
```

This project is part of my hands-on **Docker and DevOps learning projects**.
