# Incident #3 — Database Failure

## Incident Summary

The PostgreSQL database service was intentionally stopped while the Nginx and Flask services remained running.

As a result, the Flask application could no longer complete database health checks.

## Symptom

The application health endpoint returned:

```text
Database connection failed: could not translate host name "database" to address: Name or service not known
```

The application itself remained accessible through Nginx.

## Investigation

The Compose services were inspected:

```bash
sudo docker compose ps -a
```

The PostgreSQL container was shown as:

```text
Exited (0)
```

The database logs were then checked:

```bash
sudo docker compose logs database --tail 50
```

The logs showed:

```text
received fast shutdown request
database system is shut down
```

This indicated that PostgreSQL had been cleanly stopped rather than crashing.

The Flask application logs were also inspected:

```bash
sudo docker compose logs app --tail 20
```

The application remained running, but the `/health` request changed from HTTP `200` to HTTP `500` after the database was stopped.

## Root Cause

The PostgreSQL service was unavailable.

The database container had been intentionally stopped:

```bash
sudo docker compose stop database
```

The Flask application was still running, but its `/health` endpoint requires a connection to PostgreSQL.

Therefore, the application could not perform its database health check while PostgreSQL was unavailable.

## Resolution

The PostgreSQL service was restarted:

```bash
sudo docker compose start database
```

The running services were verified:

```bash
sudo docker compose ps
```

All three services were running again.

## Verification

The application health endpoint was tested:

```bash
curl http://localhost:8080/health
```

Result:

```text
OK - Application and Database are healthy
```

This confirmed that PostgreSQL was available again and that the Flask application could successfully reconnect to the database.

## Root Cause Classification

**Category:** Service Availability / Database

**Cause:** PostgreSQL container was unavailable.

**Resolution:** Restarted the PostgreSQL service and verified application-to-database connectivity.

## Lesson Learned

A running application container does not necessarily mean the application is healthy.

Application health can depend on external services such as databases.

When troubleshooting a database-related application failure, check:

1. Whether the database container is running.
2. The database container's exit status.
3. Database logs.
4. Application logs.
5. Database connectivity from the application.
6. Whether the database is listening on the expected port.
7. Whether the application recovers after the database becomes available again.
