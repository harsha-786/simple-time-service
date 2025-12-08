
import os
import time
from typing import Optional

from fastapi import FastAPI, Request
import uvicorn

app = FastAPI(title="SimpleTimeService", version="1.0.0")


def client_ip(request: Request) -> Optional[str]:
    # Determine client IP in a proxy-friendly way:
    # 1) X-Forwarded-For (first IP)
    # 2) X-Real-IP
    # 3) request.client.host
    xff = request.headers.get("x-forwarded-for")
    if xff:
        parts = [p.strip() for p in xff.split(",")]
        for ip in parts:
            if ip:
                return ip

    xrip = request.headers.get("x-real-ip")
    if xrip:
        return xrip

    return request.client.host if request.client else None


@app.get("/", summary="Current UTC timestamp and client IP")
async def root(request: Request):
    ts = time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime()) + f".{time.time_ns() % 1_000_000_000:09d}Z"
    return {"timestamp": ts, "ip": client_ip(request)}


@app.get("/healthz", summary="Health check")
async def health():
    return "ok"


if __name__ == "__main__":
    port = int(os.getenv("PORT", "8080"))
    uvicorn.run(app, host="0.0.0.0", port=port)
