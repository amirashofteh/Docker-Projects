# Blackbox Exporter + Prometheus + Grafana

A Docker Compose monitoring stack that uses **Blackbox Exporter** to probe HTTP/HTTPS endpoints, **Prometheus** to collect the resulting metrics, and **Grafana** to visualize them.

The project demonstrates how to build a complete external-service monitoring pipeline using Docker.

## Architecture

```text
                         Internet
                            │
                            ▼
                   ┌─────────────────┐
                   │ Target Website  │
                   │  example.com    │
                   └────────┬────────┘
                            │
                       HTTP/HTTPS
                            │
                            ▼
                   ┌─────────────────┐
                   │    Blackbox     │
                   │    Exporter     │
                   │   Container     │
                   │     :9115       │
                   └────────┬────────┘
                            │
                         Metrics
                            │
                            ▼
                   ┌─────────────────┐
                   │   Prometheus    │
                   │   Container     │
                   │     :9090       │
                   └────────┬────────┘
                            │
                          PromQL
                            │
                            ▼
                   ┌─────────────────┐
                   │     Grafana     │
                   │   Container     │
                   │     :3000       │
                   └─────────────────┘
```

All three services communicate through the Docker Compose network.

## Components

| Component         | Purpose                       |            Port |
| ----------------- | ----------------------------- | --------------: |
| Blackbox Exporter | Performs HTTP/HTTPS probes    | `9116` → `9115` |
| Prometheus        | Collects and stores metrics   |          `9090` |
| Grafana           | Visualizes monitoring metrics |          `3000` |

## Project Structure

```text
Blackbox_Prometheus_Grafana/
│
├── docker-compose.yml
│
├── blackbox/
│   └── blackbox.yml
│
├── prometheus/
│   └── prometheus.yml
│
└── grafana/
```

## Requirements

* Docker
* Docker Compose
* Internet connectivity
* A web browser

Check Docker:

```bash
docker --version
```

Check Docker Compose:

```bash
docker compose version
```

## Configuration

### Blackbox Exporter

The Blackbox configuration defines an HTTP probing module:

```yaml
modules:

  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions:
        - HTTP/1.1
        - HTTP/2
      method: GET
      preferred_ip_protocol: ip4
```

The `http_2xx` module:

* Uses the HTTP prober
* Has a 5-second timeout
* Supports HTTP/1.1 and HTTP/2
* Uses the GET method
* Prefers IPv4
* Treats successful HTTP responses as successful probes

## Prometheus Configuration

Prometheus scrapes the Blackbox Exporter using the `/probe` endpoint.

```yaml
scrape_configs:

  - job_name: "blackbox"
    metrics_path: /probe

    static_configs:
      - targets:
          - https://example.com

    params:
      module:
        - http_2xx
```

Prometheus uses relabeling to pass the target URL to Blackbox:

```yaml
relabel_configs:

  - source_labels: [__address__]
    target_label: __param_target

  - source_labels: [__param_target]
    target_label: instance

  - target_label: __address__
    replacement: blackbox:9115
```

The important part is:

```yaml
replacement: blackbox:9115
```

`blackbox` is the Docker Compose service name. Docker's internal DNS allows Prometheus to resolve it automatically.

Therefore, Prometheus communicates with:

```text
http://blackbox:9115
```

rather than:

```text
http://localhost:9115
```

## Start the Stack

From the project directory:

```bash
docker compose up -d
```

Or, on systems using the legacy Compose command:

```bash
docker-compose up -d
```

Check the containers:

```bash
docker ps
```

Expected containers:

```text
blackbox-exporter
prometheus
grafana
```

## Access the Services

### Blackbox Exporter

Because the host port is mapped from `9116` to the container's `9115`:

```text
http://localhost:9116
```

### Prometheus

```text
http://localhost:9090
```

### Grafana

```text
http://localhost:3000
```

## Test Blackbox Exporter

Test an HTTP probe directly:

```bash
curl "http://localhost:9116/probe?target=https://example.com&module=http_2xx"
```

To see the most important metrics:

```bash
curl "http://localhost:9116/probe?target=https://example.com&module=http_2xx" \
  | grep -E "probe_success|probe_http_status_code|probe_duration_seconds"
```

A successful probe should contain:

```text
probe_success 1
```

## Test Prometheus → Blackbox Communication

The containers communicate using the Docker network.

Test from inside the Prometheus container:

```bash
docker exec prometheus wget -qO- \
"http://blackbox:9115/probe?target=https://example.com&module=http_2xx" \
| grep probe_success
```

Expected result:

```text
probe_success 1
```

This confirms that Prometheus can reach Blackbox Exporter through the Docker network.

## Prometheus Queries

Open:

```text
http://localhost:9090
```

Useful queries include:

### Probe Success

```promql
probe_success
```

Returns:

```text
1 = successful probe
0 = failed probe
```

### HTTP Status Code

```promql
probe_http_status_code
```

Example:

```text
200
```

### Probe Duration

```promql
probe_duration_seconds
```

Shows how long the complete probe took.

### HTTP Request Duration

```promql
probe_http_duration_seconds
```

This can be used to investigate different stages of the HTTP request.

## Grafana

Open:

```text
http://localhost:3000
```

Configure Prometheus as the Grafana data source.

Because Grafana is running inside Docker, use:

```text
http://prometheus:9090
```

Do not use:

```text
http://localhost:9090
```

The latter refers to the Grafana container itself.

## Recommended Dashboard

A useful Blackbox monitoring dashboard can contain:

### Availability

```promql
probe_success
```

### HTTP Status

```promql
probe_http_status_code
```

### Response Time

```promql
probe_duration_seconds
```

### HTTP Duration

```promql
probe_http_duration_seconds
```

### DNS Lookup Time

```promql
probe_dns_lookup_time_seconds
```

### TLS Duration

```promql
probe_tls_duration_seconds
```

### SSL Certificate Expiry

```promql
probe_ssl_earliest_cert_expiry
```

Certificate expiry can be converted into days remaining with:

```promql
(probe_ssl_earliest_cert_expiry - time()) / 86400
```

## Adding More Targets

Additional endpoints can be added to `prometheus/prometheus.yml`:

```yaml
static_configs:
  - targets:
      - https://example.com
      - https://google.com
      - https://github.com
```

Prometheus will then ask Blackbox Exporter to probe each target.

The resulting architecture becomes:

```text
                  ┌── example.com
                  │
Blackbox Exporter ├── google.com
                  │
                  └── github.com
                         │
                         ▼
                     Prometheus
                         │
                         ▼
                      Grafana
```

## Useful Docker Commands

View running containers:

```bash
docker ps
```

View all containers:

```bash
docker ps -a
```

View Blackbox logs:

```bash
docker logs blackbox-exporter
```

View Prometheus logs:

```bash
docker logs prometheus
```

View Grafana logs:

```bash
docker logs grafana
```

Restart the stack:

```bash
docker compose restart
```

Stop the stack:

```bash
docker compose down
```

Stop and remove the containers:

```bash
docker compose down
```

## Troubleshooting

### Port 9116 Already in Use

Check which process is using the port:

```bash
sudo ss -ltnp | grep 9116
```

You can also check Docker:

```bash
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

### Blackbox Probe Fails

Check the probe directly:

```bash
curl "http://localhost:9116/probe?target=https://example.com&module=http_2xx"
```

Look for:

```text
probe_success 0
```

Then inspect the output for DNS, connection, TLS, or HTTP errors.

### Prometheus Cannot Reach Blackbox

Test from inside Prometheus:

```bash
docker exec prometheus wget -qO- \
"http://blackbox:9115/probe?target=https://example.com&module=http_2xx"
```

Verify the Docker network:

```bash
docker network ls
```

Then inspect the Compose network:

```bash
docker network inspect blackbox_prometheus_grafana_default
```

Both `prometheus` and `blackbox-exporter` should be connected to the same network.

## Learning Objectives

This project demonstrates:

* Docker Compose
* Multi-container applications
* Docker networking
* Container service discovery
* Prometheus configuration
* Prometheus scrape jobs
* Prometheus relabeling
* Blackbox Exporter
* HTTP/HTTPS monitoring
* PromQL
* Grafana data sources
* Monitoring dashboards
* Service availability monitoring

## Future Improvements

Possible extensions:

* Add multiple HTTP/HTTPS targets
* Monitor TCP services
* Monitor ICMP/ping
* Monitor DNS resolution
* Monitor SSL certificate expiration
* Create Grafana alert rules
* Add persistent Prometheus storage
* Add persistent Grafana storage
* Add Alertmanager
* Add Slack/Discord/email notifications
* Create separate Blackbox modules for HTTP, TCP, ICMP, and DNS
* Add Docker healthchecks
* Add GitHub Actions for configuration validation

## Final Monitoring Pipeline

```text
                     TARGETS
                        │
              ┌─────────┴─────────┐
              │                   │
          HTTPS Probe         HTTPS Probe
              │                   │
              └─────────┬─────────┘
                        ▼
               BLACKBOX EXPORTER
                     :9115
                        │
                     Metrics
                        │
                        ▼
                   PROMETHEUS
                      :9090
                        │
                     PromQL
                        │
                        ▼
                    GRAFANA
                      :3000
                        │
                        ▼
                 MONITORING DASHBOARD
```

## Author

Built as part of a hands-on Docker, Linux, and DevOps learning project.
