# Node.js Web Application with Docker

A simple Node.js HTTP web application containerized with Docker.

This project demonstrates how to build a Node.js application into a Docker image, run it as a container, and expose the application to the host machine through port mapping.

## Project Structure

```text
Nodejs_Web_Application/
├── Dockerfile
├── Nodejswebapplication.js
├── package.json
└── package-lock.json
```

## Technologies Used

* Node.js
* Docker
* npm
* JavaScript
* Alpine Linux

## Application

The application uses Node.js's built-in `http` module to create a simple web server.

The server listens on:

```text
0.0.0.0:3001
```

When a client connects, it returns:

```text
Im nodejs running inside Docker!!!
```

## Dockerfile

The Dockerfile uses the official Node.js Alpine image:

```dockerfile
FROM node:14-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3001

ENV NAME=Nodejswebapp

CMD ["node", "Nodejswebapplication.js"]
```

## Build the Docker Image

Clone the repository and enter the project directory:

```bash
git clone <your-repository-url>
cd Nodejs_Web_Application
```

Build the Docker image:

```bash
sudo docker build -t nodejswebapp .
```

Verify that the image was created:

```bash
sudo docker images
```

You should see:

```text
nodejswebapp
```

## Run the Container

Start the application:

```bash
sudo docker run -d -p 3001:3001 --name nodejswebapp nodejswebapp
```

The `-p` option maps the host port to the container port:

```text
Host:      3001
             ↓
Container: 3001
```

## Check the Container

View running containers:

```bash
sudo docker ps
```

Check application logs:

```bash
sudo docker logs nodejswebapp
```

Expected output:

```text
Server running at http://0.0.0.0:3001/
```

## Access the Application

Open a web browser and visit:

```text
http://localhost:3001
```

You should see:

```text
Im nodejs running inside Docker!!!
```

You can also test it from the terminal:

```bash
curl http://localhost:3001
```

Expected response:

```text
Im nodejs running inside Docker!!!
```

## Stop the Container

```bash
sudo docker stop nodejswebapp
```

## Start It Again

```bash
sudo docker start nodejswebapp
```

## Remove the Container

```bash
sudo docker rm nodejswebapp
```

If the container is still running:

```bash
sudo docker rm -f nodejswebapp
```

## Remove the Image

```bash
sudo docker rmi nodejswebapp
```

## How It Works

The basic workflow is:

```text
Node.js Application
        ↓
    package.json
        ↓
     Dockerfile
        ↓
  docker build
        ↓
   Docker Image
        ↓
    docker run
        ↓
 Docker Container
        ↓
  Port 3001
        ↓
     Browser
```

The application runs **inside the Docker container**, while Docker publishes port `3001` from the container to port `3001` on the host.

## What I Learned

This project demonstrates the following Docker concepts:

* Creating a Dockerfile
* Using an official Docker image
* Using `WORKDIR`
* Copying application files into an image
* Installing Node.js dependencies with `npm install`
* Exposing a container port
* Setting environment variables
* Defining a container startup command with `CMD`
* Building Docker images
* Running Docker containers
* Mapping host ports to container ports
* Viewing container logs
* Managing Docker containers and images

## Future Improvements

Possible improvements for this project include:

* Use a newer supported Node.js LTS image
* Add a `.dockerignore` file
* Add Docker Compose
* Add environment-based configuration
* Add a frontend
* Add a database
* Add health checks
* Run the application as a non-root user
* Add automated Docker image builds with GitHub Actions

## Author

**Myrkur**

This project is part of a practical Docker learning series focused on building real-world projects and developing containerization skills.
