#!/bin/bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Deploying with Tailscale..."

# --- Validate .env ---
[ ! -f .env ] && {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] .env missing. Copy .env.example."
    exit 1
}

# --- Start Services ---
docker compose up -d || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Docker Compose failed."
    exit 1
}

# --- Tailscale Status ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Tailscale IP:"
docker exec tailscale tailscale ip -4 || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] Tailscale not fully initialized."
}

