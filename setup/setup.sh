#!/bin/bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Starting Tailscale-focused setup..."

# --- Install Tailscale ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sudo sh || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Tailscale install failed. Aborting."
    exit 1
}

# --- Docker Setup (Unchanged) ---
curl -fsSL https://get.docker.com | sudo sh || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Docker install failed. Aborting."
    exit 1
}
sudo usermod -aG docker $USER

# --- Firewall (Allow Tailscale UDP) ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Configuring UFW..."
sudo ufw allow 41641/udp  # Tailscale
sudo ufw allow 2222/tcp   # SSH
sudo ufw --force enable

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] Setup complete. Reboot to apply changes."

