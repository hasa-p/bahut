#!/bin/bash
# Initial server setup with Cloudflare Tunnel

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Starting server setup..."

# --- System Updates ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Updating system packages..."
sudo apt update && sudo apt upgrade -y || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Failed to update packages. Aborting."
    exit 1
}

# --- Install Core Tools ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Installing Docker, UFW, Fail2Ban..."
sudo apt install -y curl git ufw fail2ban htop || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Package installation failed. Aborting."
    exit 1
}

# --- Docker Setup ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Installing Docker..."
curl -fsSL https://get.docker.com | sudo sh || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Docker installation failed. Aborting."
    exit 1
}
sudo usermod -aG docker $USER || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] Failed to add user to Docker group (may need logout)."
}

# --- Cloudflared Setup ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Installing Cloudflared..."
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Cloudflared download failed. Aborting."
    exit 1
}
sudo mv cloudflared /usr/local/bin/ && sudo chmod +x /usr/local/bin/cloudflared || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Cloudflared setup failed. Aborting."
    exit 1
}

# --- Firewall Configuration ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Configuring UFW firewall..."
sudo ufw allow 2222/tcp  # Custom SSH port
sudo ufw allow 80/tcp    # For Cloudflare Tunnel
sudo ufw --force enable || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] UFW enable failed (may already be active)."
}

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] Setup completed. Reboot recommended."

