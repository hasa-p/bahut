#!/bin/bash
# Deploys all services with Docker Compose

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Starting deployment..."

# --- Validate .env ---
if [ ! -f .env ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] .env file missing! Copy from .env.example."
    exit 1
fi

# --- Start Services ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Launching containers..."
docker compose up -d || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Docker Compose failed. Check logs."
    exit 1
}

# --- Verify Containers ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Checking container status..."
if ! docker ps --filter "name=nextcloud" --format '{{.Status}}' | grep -q 'Up'; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Nextcloud failed to start."
    docker logs nextcloud
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] Deployment complete. Services:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

