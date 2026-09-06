# Docker Resource Management

A practical Docker project demonstrating how to control, monitor, and troubleshoot container CPU and memory resources using Docker Compose.

## Objectives

* Apply CPU limits to containers
* Apply memory limits and reservations
* Observe real container resource consumption
* Demonstrate Docker OOM behavior
* Monitor container resources with `docker stats`
* Verify resource configuration with `docker inspect`

## Project Structure

```text
Docker_Resource_Managment/
├── docker-compose.yml
├── README.md
├── scripts/
│   ├── cpu-test.sh
│   ├── memory-test.sh
│   └── monitor.sh
└── stress/
    └── Dockerfile
```

## Architecture

The project uses a Debian-based container running `stress-ng` to generate controlled CPU and memory workloads.

```text
Docker Compose
      │
      ▼
resource-stress
      │
      ├── CPU workload
      └── Memory workload
             │
             ▼
     Docker Resource Limits
       ├── CPU: 0.5
       └── Memory: 512 MiB
```

## Resource Configuration

The container is configured with:

| Resource               | Configuration |
| ---------------------- | ------------: |
| CPU limit              |       0.5 CPU |
| Memory limit           |       512 MiB |
| Memory reservation     |       128 MiB |
| Normal memory workload |       256 MiB |
| CPU workload           |      1 worker |

The memory reservation provides a lower resource reservation, while the limit defines the maximum memory the container can consume.

## Running the Project

Start the container:

```bash
sudo docker compose up -d
```

Check the running containers:

```bash
sudo docker compose ps
```

Monitor resource usage:

```bash
sudo docker stats resource-stress
```

Stop the project:

```bash
sudo docker compose down
```

## CPU Limit Experiment

The container was configured with a CPU limit of:

```yaml
cpus: "0.5"
```

With the CPU stress workload running, Docker reported approximately:

```text
CPU: 50%
```

This demonstrates that the container was restricted to approximately half of one CPU core.

When the CPU limit was removed, the same workload reached approximately:

```text
CPU: 200%
```

Docker reports CPU usage relative to a single CPU core, so values above 100% indicate usage of multiple cores.

### Result

```text
0.5 CPU limit  → ~50% CPU
No CPU limit   → ~200% CPU
```

## Memory Limit Experiment

The container has a memory limit of:

```yaml
memory: 512M
```

The workload was temporarily increased to:

```text
--vm-bytes 1G
```

This intentionally attempted to consume more memory than the container was allowed to use.

Docker reported:

```text
Memory: 508 MiB / 512 MiB
Memory %: 99.22%
Status=running
OOMKilled=true
```

After the container stopped:

```text
Status=exited
OOMKilled=true
ExitCode=0
```

This confirmed that Docker's memory limit was enforced and the workload triggered an out-of-memory condition.

## Normal Monitoring

The project includes:

```text
scripts/monitor.sh
```

The script continuously displays:

* CPU usage
* Memory usage
* Memory percentage
* PID count
* Container state
* OOM status

Example:

```text
========================================
 Docker Resource Monitor
========================================

CPU: 50.44%
Memory: 508MiB / 512MiB
Memory %: 99.22%
PIDs: 4

Status=running OOMKilled=true
```

## Final Stable Configuration

After testing the OOM condition, the workload was returned to:

```text
256M
```

while keeping the memory limit at:

```text
512M
```

Final observed resource usage:

```text
CPU: 50.10%
Memory: 264.1MiB / 512MiB
Memory: 51.59%
PIDs: 4
```

This provides a stable configuration for normal project execution.

## Verification

Inspect the container resource configuration:

```bash
sudo docker inspect resource-stress \
  --format 'CPU={{.HostConfig.NanoCpus}} Memory={{.HostConfig.Memory}} Reservation={{.HostConfig.MemoryReservation}}'
```

Check runtime resource usage:

```bash
sudo docker stats resource-stress --no-stream
```

Check OOM status:

```bash
sudo docker inspect resource-stress \
  --format 'Status={{.State.Status}} OOMKilled={{.State.OOMKilled}} ExitCode={{.State.ExitCode}}'
```

Validate the Compose configuration:

```bash
sudo docker compose config
```

## Key Lessons

### CPU limits

CPU limits control how much CPU time a container can consume.

```text
0.5 CPU ≈ half of one CPU core
```

### Memory limits

Memory limits establish a hard upper boundary for container memory consumption.

If the workload exceeds the limit, the kernel/Docker memory-control mechanism can trigger an OOM kill.

### Reservations

Memory reservations indicate resources that should be considered for the container under resource-management scenarios, but they are not the same as the hard memory limit.

### Monitoring

`docker stats` provides real-time container resource information and is useful for quickly identifying CPU, memory, and process usage.

### OOM troubleshooting

`docker inspect` provides useful state information such as:

```text
OOMKilled=true
```

which can distinguish an out-of-memory event from a normal application exit.

## Troubleshooting

### Container immediately stops

Check:

```bash
sudo docker inspect resource-stress \
  --format 'Status={{.State.Status}} OOMKilled={{.State.OOMKilled}} ExitCode={{.State.ExitCode}}'
```

If:

```text
OOMKilled=true
```

the container exceeded its memory constraint.

### Check current resource consumption

```bash
sudo docker stats resource-stress --no-stream
```

### Check the effective Compose configuration

```bash
sudo docker compose config
```

## Skills Demonstrated

* Docker resource limits
* Docker Compose
* CPU throttling
* Memory limits
* Memory reservations
* OOM behavior
* `docker stats`
* `docker inspect`
* Linux resource management
* Container troubleshooting
* Bash scripting
