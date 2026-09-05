# Docker Multi-Stage Build

A practical Docker project demonstrating how **multi-stage builds** separate the build environment from the production runtime image.

## 🎯 Goal

Build a minimal Node.js application using Docker multi-stage builds and compare the final image size with a traditional single-stage build.

The main objective is to understand how to:

* Separate build-time and runtime environments
* Use multiple `FROM` stages
* Copy only required artifacts between stages
* Use a smaller runtime image
* Reduce the final Docker image size

## 📁 Project Structure

```text
Docker_Multi_Stage_Build/
├── .dockerignore
├── Dockerfile
└── app/
    ├── package.json
    └── server.js
```

## 🏗️ Build Process

### Single-stage build

The baseline image uses the full Node.js image:

```text
node:22
   ↓
Install / Build
   ↓
Application
   ↓
Final Image
```

Result:

```text
1.13 GB
```

### Multi-stage build

The final Dockerfile separates building from runtime:

```text
Builder Stage
node:22
   ↓
npm run build
   ↓
dist/
   │
   │ COPY --from=builder
   ▼
Runtime Stage
node:22-slim
   ↓
Production application
```

Result:

```text
227 MB
```

## 📊 Result

| Build        | Image Size |
| ------------ | ---------: |
| Single-stage |    1.13 GB |
| Multi-stage  |     227 MB |
| Reduction    |       ~80% |

The multi-stage image is approximately **80% smaller** than the single-stage image.

## 🚀 Build

Build the multi-stage image:

```bash
sudo docker build -t node-multi-stage .
```

Run it:

```bash
sudo docker run -d \
  --name node-multi-stage \
  -p 3000:3000 \
  node-multi-stage
```

Test:

```bash
curl http://localhost:3000
```

Expected:

```text
Docker multi-stage build is working!
```

## 🔍 Verify the Runtime Image

Check the application files:

```bash
sudo docker run --rm node-multi-stage ls -la /app
```

Check the build output:

```bash
sudo docker run --rm node-multi-stage ls -la /app/dist
```

The runtime image contains the required production files without the original build/source environment.

## 🧠 Key Docker Concepts

* `FROM ... AS builder`
* Multiple Docker build stages
* `COPY --from=builder`
* Build-time vs runtime dependencies
* Smaller production images
* Minimal runtime base images
* Docker image size optimization

## 🧹 Cleanup

Remove the container:

```bash
sudo docker rm -f node-multi-stage
```

Remove the image:

```bash
sudo docker rmi node-multi-stage
```

## ✅ Project Status

**Completed — Project 15**

This project demonstrates the practical use of Docker multi-stage builds to create **smaller and cleaner production images**.
