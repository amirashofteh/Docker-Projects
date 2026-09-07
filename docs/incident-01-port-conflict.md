# Incident #1 — Docker Port Conflict

## Incident Summary

The Docker application could not start the Nginx service because host port `8080` was already being used by another container.

## Symptom

Running:

```bash
sudo docker compose up -d
```

resulted in a port allocation error because Docker could not bind host port `8080`.

## Investigation

Checked the running containers:

```bash
sudo docker ps
```

A container named `port-conflict` was using:

```text
0.0.0.0:8080->80/tcp
```

The host port was also confirmed with:

```bash
sudo ss -ltnp | grep :8080
```

## Root Cause

The `port-conflict` container had already claimed host port `8080`.

Our Nginx service was configured to use the same port:

```yaml
ports:
  - "8080:80"
```

Docker cannot assign the same host port to two containers.

## Resolution

The conflicting container was stopped:

```bash
sudo docker stop port-conflict
```

Then removed:

```bash
sudo docker rm port-conflict
```

The Docker Compose application was started again:

```bash
sudo docker compose up -d
```

## Verification

Checked the running services:

```bash
sudo docker compose ps
```

The Nginx, Flask application, and PostgreSQL containers were running.

Application test:

```bash
curl http://localhost:8080
```

Result:

```text
Docker Troubleshooting Lab - API is running
```

Database connectivity test:

```bash
curl http://localhost:8080/health
```

Result:

```text
OK - Application and Database are healthy
```

## Root Cause Classification

**Category:** Networking / Port Allocation

**Cause:** Host port `8080` was already allocated to another Docker container.

**Resolution:** Identified and removed the conflicting container, then restarted the application stack.

## Lesson Learned

Before stopping or removing a process or container occupying a required port in a production environment, first identify what owns the port and determine whether it is a legitimate service.
