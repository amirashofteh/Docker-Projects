# MySQL + phpMyAdmin with Docker Compose

A simple Docker Compose project that sets up a **MySQL 8.0 database server** together with **phpMyAdmin** for web-based database management.

The project demonstrates how to run multiple related services with Docker Compose, connect containers through a Docker network, expose services to the host, and persist MySQL data using a named Docker volume.

## 📌 Project Architecture

```text
                    ┌─────────────────────┐
                    │       Browser       │
                    │   localhost:8080    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      phpMyAdmin     │
                    │       :80           │
                    └──────────┬──────────┘
                               │
                         Docker Network
                               │
                               ▼
                    ┌─────────────────────┐
                    │       MySQL 8.0     │
                    │       :3306         │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    mysql_data       │
                    │   Docker Volume     │
                    └─────────────────────┘
```

## 🛠️ Technologies Used

* Docker
* Docker Compose
* MySQL 8.0
* phpMyAdmin
* Docker Volumes
* Docker Networking

## 📂 Project Structure

```text
MySQL_PHPmyAdmin_Docker/
├── docker-compose.yaml
└── README.md
```

## ⚙️ Docker Compose Configuration

The project contains two services:

### MySQL

The MySQL container uses the official `mysql:8.0` image.

Configuration:

```yaml
mysql:
  image: mysql:8.0
  container_name: mysql-server
  environment:
    MYSQL_ROOT_PASSWORD: Password
    MYSQL_DATABASE: sampledb
  ports:
    - "3306:3306"
  volumes:
    - mysql_data:/var/lib/mysql
```

The configuration:

* Creates a MySQL 8.0 container.
* Sets the root password.
* Creates a database named `sampledb`.
* Exposes MySQL on port `3306`.
* Stores database files in the persistent `mysql_data` volume.

### phpMyAdmin

phpMyAdmin provides a web interface for managing the MySQL database.

```yaml
phpmyadmin:
  image: phpmyadmin/phpmyadmin
  container_name: phpmyadmin
  environment:
    PMA_HOST: mysql
    PMA_PORT: 3306
  ports:
    - "8080:80"
  depends_on:
    - mysql
```

The important part is:

```yaml
PMA_HOST: mysql
```

phpMyAdmin connects to the MySQL container using the Docker Compose service name `mysql`.

You do **not** need to use `localhost` between the containers.

## 🚀 How to Run

Clone the repository or enter the project directory:

```bash
cd MySQL_PHPmyAdmin_Docker
```

Start the containers:

```bash
docker compose up -d
```

Check the running containers:

```bash
docker ps
```

You should see:

```text
mysql-server
phpmyadmin
```

## 🌐 Access phpMyAdmin

Open your browser and go to:

```text
http://localhost:8080
```

Use the following credentials:

```text
Server:   mysql
Username: root
Password: Password
```

The `sampledb` database should be available after logging in.

## 🗄️ Access MySQL Directly

You can also connect to MySQL from the terminal.

Enter the MySQL container:

```bash
docker exec -it mysql-server mysql -u root -p
```

Enter the configured password:

```text
Password
```

Then check the available databases:

```sql
SHOW DATABASES;
```

You should see:

```text
information_schema
mysql
performance_schema
sampledb
sys
```

## 💾 Persistent Storage

This project uses a named Docker volume:

```yaml
volumes:
  mysql_data:
```

The volume is mounted to:

```text
/var/lib/mysql
```

inside the MySQL container.

This means the database data survives container recreation.

For example:

```bash
docker compose down
docker compose up -d
```

The MySQL container is removed and recreated, but the data stored in `mysql_data` remains.

To view Docker volumes:

```bash
docker volume ls
```

To inspect the volume:

```bash
docker volume inspect mysql_data
```

## 🔍 Useful Docker Commands

View running containers:

```bash
docker ps
```

View all containers:

```bash
docker ps -a
```

View logs:

```bash
docker compose logs
```

View MySQL logs:

```bash
docker compose logs mysql
```

View phpMyAdmin logs:

```bash
docker compose logs phpmyadmin
```

Follow logs in real time:

```bash
docker compose logs -f
```

Stop the services:

```bash
docker compose stop
```

Start them again:

```bash
docker compose start
```

Stop and remove the containers:

```bash
docker compose down
```

Stop and remove containers **and the database volume**:

```bash
docker compose down -v
```

⚠️ **Warning:** `docker compose down -v` deletes the `mysql_data` volume and therefore removes the stored MySQL data.

## 🔗 Service Communication

Docker Compose automatically creates a network for the services.

The containers can communicate using their **service names**.

In this project:

```text
phpmyadmin → mysql:3306
```

The phpMyAdmin configuration:

```yaml
PMA_HOST: mysql
PMA_PORT: 3306
```

allows phpMyAdmin to resolve the MySQL container through Docker's internal DNS.

The browser, however, communicates with phpMyAdmin through the host:

```text
Browser → localhost:8080 → phpMyAdmin
```

## 🧪 Testing

After starting the project:

```bash
docker compose up -d
```

Verify the containers:

```bash
docker ps
```

Verify MySQL:

```bash
docker compose logs mysql
```

Then open:

```text
http://localhost:8080
```

Log in with:

```text
Username: root
Password: Password
Server: mysql
```

Create a test table or database through phpMyAdmin.

Then recreate the containers:

```bash
docker compose down
docker compose up -d
```

Log in again and verify that your data is still present.

This demonstrates Docker volume persistence.

## 🧹 Cleanup

To remove the containers and network:

```bash
docker compose down
```

To completely remove the project containers, network, and database data:

```bash
docker compose down -v
```

## 🎯 What I Learned

This project demonstrates several important Docker concepts:

* Running multiple containers with Docker Compose
* Using official Docker images
* Configuring containers with environment variables
* Container-to-container communication
* Docker Compose service discovery
* Port mapping
* Named Docker volumes
* Persistent database storage
* Using phpMyAdmin to manage a containerized MySQL database
* Managing multi-container applications with `docker compose`

## ⚠️ Security Note

The password in this project is intentionally simple for **learning purposes**:

```yaml
MYSQL_ROOT_PASSWORD: Password
```

For production environments, passwords should not be hardcoded in `docker-compose.yaml`.

A better approach is to use environment variables or Docker secrets.

---

## 📚 Project Goal

The goal of this project is to understand how a database and its administration interface can be deployed together using Docker Compose.

It is part of my **Docker Projects** learning series and focuses on practical experience with containerized databases, networking, volumes, and multi-container applications.
