# Nginx Reverse Proxy with Python

A simple Docker Compose project demonstrating how to use **Nginx as a reverse proxy** in front of a Python HTTP server.

The project contains two containers:

* **Nginx** — acts as the reverse proxy and exposes port `80`.
* **Python** — runs a simple HTTP server on port `8080`.

The goal of this project is to understand how multiple Docker containers communicate with each other through a Docker network and how Nginx can forward incoming HTTP requests to another container.

---

## Project Architecture

```text
                    HTTP Request
                         |
                         v
                 +---------------+
                 |     Nginx     |
                 | Reverse Proxy |
                 |    Port 80    |
                 +-------+-------+
                         |
                         | HTTP
                         v
                 +---------------+
                 |    Python     |
                 | HTTP Server   |
                 |   Port 8080   |
                 +---------------+
```

The user accesses:

```text
http://localhost
```

Nginx receives the request on port `80` and forwards it to the Python application running on port `8080`.

---

## Project Structure

```text
Nginx_Reverse_Proxy/
├── docker-compose.yaml
├── nginx/
│   └── default.conf
└── README.md
```

---

## Technologies Used

* Docker
* Docker Compose
* Nginx
* Python 3.12
* Alpine Linux
* HTTP
* Docker Networking
* Linux

---

# Docker Compose Configuration

The project uses Docker Compose to run the Nginx and Python containers.

```yaml
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"

  app:
    image: python:3.12-alpine
    command: python -m http.server 8080
```

---

## Nginx Container

The Nginx service uses the official Nginx image:

```yaml
image: nginx:latest
```

Port `80` inside the container is published to port `80` on the host:

```yaml
ports:
  - "80:80"
```

This allows the host machine to access Nginx using:

```text
http://localhost
```

---

## Python Container

The Python service uses:

```yaml
image: python:3.12-alpine
```

The container starts Python's built-in HTTP server:

```yaml
command: python -m http.server 8080
```

The Python HTTP server listens on port `8080` inside the container.

---

# Starting the Project

Navigate to the project directory:

```bash
cd ~/Projects/Docker-Projects/Nginx_Reverse_Proxy
```

Start the containers in detached mode:

```bash
sudo docker compose up -d
```

Check the running containers:

```bash
sudo docker compose ps
```

You can also check them using:

```bash
sudo docker ps
```

The two services should be running:

```text
nginx
app
```

---

# Entering the Nginx Container

During this project, we logged into the running Nginx container to inspect and modify its configuration.

First, the running containers were checked:

```bash
sudo docker ps
```

The Nginx container was identified as:

```text
nginx_reverse_proxy-nginx-1
```

We then opened an interactive shell inside the container:

```bash
sudo docker exec -it nginx_reverse_proxy-nginx-1 /bin/bash
```

Once inside the container, we navigated to the Nginx configuration directory:

```bash
cd /etc/nginx/conf.d
```

The contents of the directory were checked:

```bash
ls
```

The default configuration file was located at:

```text
/etc/nginx/conf.d/default.conf
```

---

# Modifying default.conf

The default Nginx configuration was opened using `vi`:

```bash
vi default.conf
```

The default configuration was modified so that Nginx works as a reverse proxy for the Python application.

The configuration was changed to:

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://app:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

The important line is:

```nginx
proxy_pass http://app:8080;
```

This tells Nginx to forward incoming HTTP requests to the Python container.

---

# How Docker Container Networking Works

The Python service is named:

```yaml
app:
```

Docker Compose automatically creates a network for the services in the project.

Because of Docker's internal DNS, Nginx can communicate with the Python container using:

```text
app:8080
```

instead of using the Python container's IP address.

The communication therefore looks like this:

```text
Browser
   |
   | HTTP :80
   v
Nginx
   |
   | http://app:8080
   v
Python HTTP Server
```

This is one of the important concepts demonstrated by this project.

---

# Testing the Nginx Configuration

After modifying `default.conf`, the Nginx configuration can be tested from inside the container:

```bash
nginx -t
```

A successful test should indicate that the configuration syntax is valid.

If the configuration is valid, Nginx can be reloaded:

```bash
nginx -s reload
```

Alternatively, exit the container:

```bash
exit
```

and restart the Nginx container:

```bash
sudo docker restart nginx_reverse_proxy-nginx-1
```

---

# Testing the Reverse Proxy

After configuring Nginx, the application can be tested from the host machine.

Using `curl`:

```bash
curl http://localhost
```

Or open a browser and visit:

```text
http://localhost
```

The request flow is:

```text
http://localhost
       |
       v
Host Port 80
       |
       v
Nginx Container
       |
       v
http://app:8080
       |
       v
Python HTTP Server
```

If everything is configured correctly, the Python HTTP server response should be displayed.

---

# Testing the Python Container Directly

The Python server listens on port `8080` inside its container.

The project does not publish port `8080` to the host.

Therefore, the Python application is intended to be accessed through Nginx:

```text
http://localhost
```

rather than directly from the host.

Inside the Docker network, however, Nginx can reach the Python service using:

```text
http://app:8080
```

---

# Checking Container Logs

Nginx logs can be viewed with:

```bash
sudo docker compose logs nginx
```

To follow the logs in real time:

```bash
sudo docker compose logs -f nginx
```

Python logs can be viewed with:

```bash
sudo docker compose logs app
```

All project logs can be viewed using:

```bash
sudo docker compose logs
```

---

# Inspecting the Nginx Configuration

The configuration inside the running container can be displayed using:

```bash
sudo docker exec -it nginx_reverse_proxy-nginx-1 cat /etc/nginx/conf.d/default.conf
```

This allows us to verify that the modified `default.conf` contains the reverse proxy configuration.

The Nginx configuration can also be tested without opening an interactive shell:

```bash
sudo docker exec nginx_reverse_proxy-nginx-1 nginx -t
```

---

# Copying default.conf From the Container

Docker provides the `docker cp` command for copying files between the host and containers.

For example:

```bash
sudo docker cp nginx_reverse_proxy-nginx-1:/etc/nginx/conf.d/default.conf ~/Desktop/default.conf
```

This copies:

```text
/etc/nginx/conf.d/default.conf
```

from the container to:

```text
~/Desktop/default.conf
```

### Important

The correct path is:

```text
~/Desktop/default.conf
```

not:

```text
~Desktop/default.conf
```

The `~` symbol represents the user's home directory.

Therefore:

```text
~
```

means:

```text
/home/helpdesk
```

while:

```text
~/Desktop
```

means:

```text
/home/helpdesk/Desktop
```

---

# Stopping the Project

To stop and remove the containers:

```bash
sudo docker compose down
```

This removes the containers and the Docker Compose network.

To stop the containers without removing them:

```bash
sudo docker compose stop
```

To start stopped containers again:

```bash
sudo docker compose start
```

---

# Recreating the Containers

If changes have been made to the Docker Compose configuration, the containers can be recreated with:

```bash
sudo docker compose down
sudo docker compose up -d
```

If the project contains locally built Docker images, the following can be used:

```bash
sudo docker compose up -d --build
```

---

# Useful Docker Commands

List running containers:

```bash
sudo docker ps
```

List all containers:

```bash
sudo docker ps -a
```

List Docker images:

```bash
sudo docker images
```

Show Docker Compose services:

```bash
sudo docker compose ps
```

View all logs:

```bash
sudo docker compose logs
```

Follow logs:

```bash
sudo docker compose logs -f
```

Open a shell inside the Nginx container:

```bash
sudo docker exec -it nginx_reverse_proxy-nginx-1 /bin/bash
```

Open a shell inside the Python container:

```bash
sudo docker exec -it nginx_reverse_proxy-app-1 /bin/sh
```

Stop the project:

```bash
sudo docker compose down
```

---

# Important Docker Concepts Learned

This project demonstrates several important Docker and DevOps concepts.

### 1. Multiple Containers

Docker Compose allows multiple services to run together as one application.

In this project:

```text
nginx
app
```

are separate containers.

### 2. Container Networking

Containers in the same Docker Compose project can communicate with each other through the Docker network.

The Python container can be reached using its service name:

```text
app
```

### 3. Reverse Proxy

Nginx receives requests from the client and forwards them to the backend application.

```text
Client → Nginx → Python
```

### 4. Port Publishing

This configuration:

```yaml
ports:
  - "80:80"
```

means:

```text
Host Port 80
      |
      v
Container Port 80
```

### 5. Internal Container Ports

The Python server listens on:

```text
8080
```

but the port does not need to be published to the host because Nginx communicates with it internally.

### 6. Docker Service Discovery

Nginx uses:

```text
app:8080
```

instead of a container IP address.

Docker's internal DNS resolves `app` to the appropriate container.

---

# Container Port vs Host Port

Understanding the difference between host and container ports is important.

For Nginx:

```yaml
ports:
  - "80:80"
```

means:

```text
HOST                         CONTAINER

localhost:80  ------------>  nginx:80
```

Nginx then communicates internally with:

```text
nginx
  |
  | Docker Network
  v
app:8080
```

The Python port `8080` is therefore internal to the Docker network.

---

# Configuration Persistence

In this project, `default.conf` was manually edited inside the running Nginx container:

```text
/etc/nginx/conf.d/default.conf
```

This is useful for learning, testing, and troubleshooting.

However, manually modifying files inside a running container is **not the preferred production approach**.

If the container is deleted and recreated, changes made directly inside the container can be lost.

A better approach is to store the configuration in the project directory and mount it into the container.

For example:

```text
Nginx_Reverse_Proxy/
├── docker-compose.yaml
├── nginx/
│   └── default.conf
└── README.md
```

The Compose file can then use a volume:

```yaml
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro

  app:
    image: python:3.12-alpine
    command: python -m http.server 8080
```

This approach makes the configuration:

* Persistent
* Version-controlled
* Reproducible
* Easy to modify
* Suitable for GitHub projects

---

# Future Improvements

Possible improvements for this project include:

1. Replace the Python built-in HTTP server with a Flask application.
2. Create a custom Dockerfile for the Python application.
3. Mount the Nginx configuration using a Docker volume.
4. Add Docker health checks.
5. Add a database container.
6. Add HTTPS/TLS.
7. Add multiple backend containers.
8. Configure Nginx load balancing.
9. Create separate development and production configurations.
10. Add Prometheus and Grafana monitoring.
11. Add automatic container restarts.
12. Add environment variables.
13. Add a custom Docker network.
14. Add CI/CD using GitHub Actions.

---

# What I Learned

By completing this project, I practiced:

* Creating multi-container applications with Docker Compose
* Using official Docker images
* Running Nginx inside Docker
* Running Python inside Docker
* Entering a running container
* Navigating the Linux filesystem inside a container
* Locating Nginx configuration files
* Editing `/etc/nginx/conf.d/default.conf`
* Configuring Nginx as a reverse proxy
* Using Docker service names for networking
* Understanding host ports and container ports
* Testing Nginx configuration with `nginx -t`
* Reloading and restarting Nginx
* Inspecting container logs
* Using `docker exec`
* Using `docker cp`
* Testing services with `curl`
* Understanding Docker Compose networking
* Understanding configuration persistence

---

# Final Architecture

```text
                         HOST MACHINE
                              |
                              |
                       http://localhost
                              |
                           Port 80
                              |
                              v
                    +-------------------+
                    |       NGINX       |
                    |   Reverse Proxy   |
                    |      :80          |
                    +---------+---------+
                              |
                              |
                       Docker Network
                              |
                              | http://app:8080
                              |
                              v
                    +-------------------+
                    |      PYTHON       |
                    |   HTTP Server     |
                    |      :8080        |
                    +-------------------+
```

The complete request flow is:

```text
Browser
   |
   | HTTP Request
   v
localhost:80
   |
   v
Nginx Container
   |
   | proxy_pass http://app:8080
   v
Python Container
   |
   v
Python HTTP Server
   |
   v
HTTP Response
   |
   v
Nginx
   |
   v
Browser
```

---

# Author

**Amir Hossein Ashofteh**

GitHub:

```text
https://github.com/amirashofteh
```

---

# Conclusion

This project provides a basic but practical example of a common web application architecture:

```text
Reverse Proxy → Backend Application
```

Nginx handles incoming HTTP requests while the Python container provides the backend HTTP service.

Although this is a small project, it introduces several concepts that are fundamental to Docker and DevOps work, including container networking, service discovery, reverse proxies, port mapping, container administration, and configuration management.
