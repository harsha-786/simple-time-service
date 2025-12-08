
# syntax=docker/dockerfile:1.6

########## Builder stage ##########
FROM python:3.12-slim AS builder
ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /tmp/build
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY simple_time_service/ /tmp/build/simple_time_service

########## Runtime stage ##########
FROM python:3.12-slim AS runtime
ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1     PATH="/opt/venv/bin:$PATH"

RUN groupadd -r app && useradd -r -g app -u 10001 app

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /tmp/build/simple_time_service /app/simple_time_service

USER 10001:10001

EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["python", "-m", "simple_time_service.main"]
