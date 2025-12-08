
# SimpleTimeService (Python / FastAPI)

A minimal web service that returns the current UTC timestamp and the requestor's IP address as **pure JSON**.

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
docker build -t simple-time-service:1.0.0 .
docker run --rm -p 8080:8080 simple-time-service:1.0.0
curl -s http://localhost:8080/ | jq .
```

Environment:
- `PORT` (optional, default: `8080`)

---

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
docker tag simple-time-service:1.0.0 harsha786docker/simple-time-service:1.0.0
docker tag simple-time-service:1.0.0 harsha786docker/simple-time-service:latest
docker push harsha786docker/simple-time-service:1.0.0
docker push harsha786docker/simple-time-service:latest
```

**(Optional) Multi-arch:**
```bash
docker buildx create --use
docker buildx build   --platform linux/amd64,linux/arm64   -t harsha786docker/simple-time-service:1.0.0   -t harsha786docker/simple-time-service:latest   --push .
```

---

## Kubernetes (optional)

See [`k8s/`](k8s/) for secure deployment. Update image to `harsha786docker/simple-time-service:1.0.0`.

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

> Reminder: **Do not push secrets**. This repo contains none by design.
