# Docker Troubleshooting Lab — Baseline

## Environment

- Docker Compose application
- Nginx reverse proxy
- Flask application
- PostgreSQL database

## Architecture

Client
  ↓
Nginx :8080
  ↓
Flask :5000
  ↓
PostgreSQL :5432

## Services

| Service | Image | Port | Status |
|---|---|---|---|
| nginx | nginx:alpine | 8080:80 | Running |
| app | Custom Flask image | 5000 | Running |
| database | postgres:16-alpine | 5432 | Running |

## Verification

### Application

```bash
curl http://localhost:8080
