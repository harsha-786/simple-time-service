# SimpleTimeService (Python / FastAPI)

A minimal web service that returns the current UTC timestamp and the requestor's IP address as **pure JSON**.

## Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- jq (for formatting JSON output in test commands)

## Response
`GET /`
```json
{
  "timestamp": "<ISO-8601 UTC>",
  "ip": "<client-ip>"
}
```

### Health
`GET /healthz` → `200 OK` and body `"ok"`.

---

## Quickstart (Docker)

```bash
docker build -t simple-time-service:1.0.1 .
docker run --rm -p 8080:8080 simple-time-service:1.0.1
curl -s http://localhost:8080/ | jq .
```

Environment:
- `PORT` (optional, default: `8080`)

## Troubleshooting: Docker Permissions
If you see errors like:
```bash
Got permission denied while trying to connect to the Docker daemon socket
```
It means your user is not part of the docker group. You can fix this by adding your user to the group:
Add current user to docker group
```bash
sudo usermod -aG docker $USER
```
Apply changes without logout
```bash
newgrp docker
```
After this, you can run Docker commands without sudo.
Note: This is a host-level permission fix. Inside the container, the app still runs as a non-root user (UID 10001).
---
## Check Container Health
The container includes a HEALTHCHECK. 
To verify use below command in another terminal:
```bash
docker ps
```
Look for STATUS:
```bash
Up 2 minutes (healthy)
```

## Container Best Practices

- Runs as **non-root** (UID 10001)
- Minimal **python:3.12-slim** base
- No pip cache, no `.pyc` files
- Small attack surface (no shell processes used at runtime)

---

## Publish Image (Docker Hub)

Using Docker Hub user `harsha786docker`:

```bash
docker login
docker tag simple-time-service:1.0.1 harsha786docker/simple-time-service:1.0.1
docker tag simple-time-service:1.0.1 harsha786docker/simple-time-service:latest
docker push harsha786docker/simple-time-service:1.0.1
docker push harsha786docker/simple-time-service:latest
```

**Docker Hub Link:** [https://hub.docker.com/r/harsha786docker/simple-time-service](https://hub.docker.com/r/harsha786docker/simple-time-service)

**(Optional) Multi-arch:**
```bash
docker buildx create --use
docker buildx build   --platform linux/amd64,linux/arm64   -t harsha786docker/simple-time-service:1.0.1   -t harsha786docker/simple-time-service:latest   --push .
```

---

## Kubernetes (optional)

See [`k8s/`](k8s/) for secure deployment. Update image to `harsha786docker/simple-time-service:1.0.1`.

---

## Push Code to GitHub

```bash
git init
git add .
git commit -m "feat: Python SimpleTimeService, Dockerfile, README, k8s"
git branch -M main
git remote add origin https://github.com/harsha-786/simple-time-service.git
git push -u origin main
```

**GitHub Link:** [https://github.com/harsha-786/simple-time-service](https://github.com/harsha-786/simple-time-service)

> Reminder: **Do not push secrets**. This repo contains none by design.
