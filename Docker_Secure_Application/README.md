# 🔐 Docker Secure Application

A practical Docker security lab demonstrating how to harden a containerized Node.js application using Docker security best practices.

The goal of this project is not to make the application itself secure, but to understand how to reduce the security risk of a container through image selection, user privileges, filesystem restrictions, Linux capabilities, privilege escalation protection, resource limits, healthchecks, and vulnerability scanning.

---

## 🎯 Project Goals

* Run containers as a non-root user
* Use a minimal Docker base image
* Reduce the container attack surface
* Make the root filesystem read-only
* Drop unnecessary Linux capabilities
* Prevent privilege escalation
* Apply CPU and memory limits
* Add a Docker healthcheck
* Use Docker Compose for security configuration
* Scan the image for vulnerabilities with Trivy
* Understand vulnerability remediation decisions

---

## 🏗️ Project Structure

```text
Docker_Secure_Application/
├── app/
│   ├── package.json
│   └── server.js
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── README.md
```

---

## 🚀 Application

The application is a minimal Node.js/Express server.

### Endpoints

```text
GET /
GET /health
```

Example response from `/`:

```json
{
  "message": "Secure Docker Application",
  "status": "running"
}
```

Health endpoint:

```json
{
  "status": "healthy"
}
```

---

# 🐳 Docker Security Controls

## 1. Minimal Base Image

The application uses:

```dockerfile
FROM node:22-alpine
```

Alpine provides a significantly smaller base image compared with the standard Debian-based Node image.

The original image was approximately:

```text
1.14 GB
```

The Alpine-based image was approximately:

```text
174 MB
```

This significantly reduces the amount of software and packages inside the container.

---

## 2. Non-Root User

The container explicitly runs as the built-in Node user:

```dockerfile
USER node
```

Verification:

```bash
sudo docker exec secure-app id
```

Result:

```text
uid=1000(node) gid=1000(node) groups=1000(node),1000(node)
```

Running applications as non-root reduces the impact of a potential container compromise.

---

## 3. Read-Only Root Filesystem

Docker Compose:

```yaml
read_only: true
```

This prevents processes inside the container from modifying the container's root filesystem.

Test:

```bash
touch /tmp/testfile
```

Result:

```text
Read-only file system
```

The application continued running normally.

---

## 4. Drop Linux Capabilities

Docker Compose:

```yaml
cap_drop:
  - ALL
```

The container runs without Linux capabilities.

Verification showed:

```text
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 0000000000000000
```

This follows the principle of least privilege.

---

## 5. Prevent Privilege Escalation

Docker Compose:

```yaml
security_opt:
  - no-new-privileges:true
```

This prevents processes from gaining additional privileges through mechanisms such as setuid/setgid binaries.

---

## 6. Resource Limits

The container is restricted to:

```yaml
deploy:
  resources:
    limits:
      cpus: "0.5"
      memory: 128M
```

Verified configuration:

```text
Memory    = 134217728 bytes
NanoCpus  = 500000000
```

Which corresponds to:

```text
Memory = 128 MiB
CPU    = 0.5 CPU
```

Resource limits help reduce the impact of resource exhaustion and runaway processes.

---

## 7. Docker Healthcheck

The Dockerfile contains:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:3000/health',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))"
```

Docker reports the container as:

```text
Up ... (healthy)
```

The healthcheck verifies that the application is actually responding rather than simply checking whether the process exists.

---

# 🧩 Docker Compose

The security configuration is managed through:

```text
docker-compose.yml
```

Main security configuration:

```yaml
services:
  secure-app:
    build:
      context: .
      dockerfile: Dockerfile

    container_name: secure-app

    ports:
      - "3000:3000"

    read_only: true

    cap_drop:
      - ALL

    security_opt:
      - no-new-privileges:true

    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: 128M

    restart: unless-stopped
```

Start the application:

```bash
sudo docker compose up -d
```

Stop it:

```bash
sudo docker compose down
```

---

# 🔍 Vulnerability Scanning

The final image was scanned using:

```bash
sudo trivy image \
  --db-repository ghcr.io/aquasecurity/trivy-db:2 \
  docker_secure_application-secure-app
```

## Results

### Alpine packages

```text
Total: 20

UNKNOWN:  0
LOW:      12
MEDIUM:   6
HIGH:     2
CRITICAL: 0
```

### Node.js packages

```text
Total: 19

UNKNOWN:  0
LOW:      1
MEDIUM:   7
HIGH:     10
CRITICAL: 1
```

The critical finding was associated with:

```text
tar
```

inside npm's internal dependency tree:

```text
/usr/local/lib/node_modules/npm/node_modules/tar
```

This was not a direct dependency of the application.

---

# 🛠️ Vulnerability Remediation

The Node.js base image was refreshed:

```bash
sudo docker pull node:22-alpine
```

The image was then rebuilt without cache:

```bash
sudo docker compose build --no-cache
```

The resulting image was rescanned.

The vulnerability count remained unchanged.

Rather than manually modifying npm's internal dependency tree, the finding was documented as a dependency of the Node/npm base environment.

This demonstrates an important DevOps security principle:

> Not every vulnerability should be blindly patched. First determine where the vulnerability exists, whether it affects your application, and whether an appropriate upstream update is available.

---

# 🔎 Final Security Verification

The final container configuration was inspected with:

```bash
sudo docker inspect secure-app --format '
User={{.Config.User}}
ReadOnly={{.HostConfig.ReadonlyRootfs}}
Memory={{.HostConfig.Memory}}
NanoCpus={{.HostConfig.NanoCpus}}
SecurityOpt={{.HostConfig.SecurityOpt}}
CapDrop={{.HostConfig.CapDrop}}
'
```

Final configuration:

```text
User=node
ReadOnly=true
Memory=134217728
NanoCpus=500000000
SecurityOpt=[no-new-privileges:true]
CapDrop=[ALL]
```

---

# 📚 What I Learned

This project demonstrated several important Docker security concepts:

* Containerizing an application does not automatically make it secure.
* Containers should avoid running as root whenever possible.
* Smaller base images reduce the attack surface.
* Read-only filesystems limit filesystem modification.
* Linux capabilities should be minimized.
* `no-new-privileges` helps prevent privilege escalation.
* Containers should have CPU and memory limits.
* Healthchecks provide application-level container health information.
* Docker Compose can define security controls declaratively.
* Vulnerability scanners identify potential security issues, but the results require interpretation.
* Vulnerabilities in base images and bundled tooling need to be handled differently from application dependencies.
* Security is a continuous process rather than a single Dockerfile setting.

---

# 🏁 Project Status

**Completed ✅**

Project 16 successfully demonstrates a hardened Docker container using practical security controls.

Next project:

**Project 17 — Docker Resource Management**
