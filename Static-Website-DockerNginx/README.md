# Static Website with Docker and Nginx

A simple Docker project that hosts a static HTML website using **Nginx** inside a Docker container.

This project was created as a first practical exercise to understand Docker containers, Docker Compose, volume mapping, port mapping, and running a web server with Nginx.

## Project Structure

```text
Static-Website-DockerNginx/
├── project.html
├── docker-compose.yaml
└── README.md
```

## 1. HTML Website

The website is a simple HTML page:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Nginx Project</title>
</head>
<body>
    <h1>Hello from Docker + Nginx!</h1>
    <p>This website is running inside an Nginx container.</p>
</body>
</html>
```

## 2. Docker Compose

The project uses the official Nginx image from Docker Hub.

```yaml
version: '3'

services:
  website:
    image: nginx:latest
    container_name: website
    volumes:
      - /home/helpdesk/Projects/Docker-Projects/Static-Website-DockerNginx/project.html:/usr/share/nginx/html/index.html
    ports:
      - "80:80"
    restart: always
```

### Configuration

* `image: nginx:latest` — uses the official Nginx Docker image.
* `container_name: website` — gives the container a simple name.
* `volumes` — mounts the local HTML file into Nginx's default web directory.
* `ports: 80:80` — maps port 80 on the host to port 80 inside the container.
* `restart: always` — automatically restarts the container if it stops.

## 3. Start the Website

From inside the project directory, run:

```bash
docker-compose up -d
```

The `-d` option runs the container in detached mode.

## 4. Check the Container

To verify that the Nginx container is running:

```bash
docker ps
```

The `website` container should appear in the list.

## 5. Access the Website

Open a browser and visit:

```text
http://localhost
```

Nginx serves the mounted HTML file from inside the container.

## 6. Stop the Project

To stop and remove the container created by Compose:

```bash
docker-compose down
```

## What I Learned

This project introduced the following Docker concepts:

* Docker containers
* Docker images
* Nginx
* Docker Compose
* Docker Compose services
* Volume mounting
* Port mapping
* Container naming
* Detached mode
* Container lifecycle management
* Checking running containers with `docker ps`

## Project Flow

```text
project.html
     │
     │ volume mount
     ▼
Nginx Container
     │
     │ port 80
     ▼
Host Machine
     │
     ▼
Web Browser
```

## Goal

This project is part of my practical Docker learning path. The goal is to gradually progress from simple containerized applications to more advanced projects involving databases, networking, multi-container applications, monitoring, automation, and CI/CD.
