#!/bin/bash
# Backup Nextcloud data

BACKUP_DIR="/mnt/storage/backups"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Starting backup..."

# --- Validate Backup Directory ---
mkdir -p "$BACKUP_DIR" || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Could not create backup directory. Aborting."
    exit 1
}

# --- Nextcloud Database Backup ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Backing up Nextcloud database..."
docker exec nextcloud_db mysqldump -u root -p"${MYSQL_ROOT_PASSWORD}" nextcloud > "$BACKUP_DIR/nextcloud_db_$TIMESTAMP.sql" || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Database backup failed."
    exit 1
}

# --- Nextcloud Data Backup ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Archiving Nextcloud data..."
tar -czvf "$BACKUP_DIR/nextcloud_data_$TIMESTAMP.tar.gz" /mnt/storage/nextcloud_data || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Data archive failed."
    exit 1
}

# --- Clean Old Backups (>30 days) ---
find "$BACKUP_DIR" -type f -mtime +30 -delete || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] Could not clean old backups."
}

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] Backup completed. Files saved to: $BACKUP_DIR"
ls -lh "$BACKUP_DIR" | grep "$TIMESTAMP"
