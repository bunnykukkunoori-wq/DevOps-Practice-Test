#!/bin/bash

# ============================
# Automated Backup Script
# Author: Bunny
# ============================

CONFIG_FILE="./backup.config"
LOG_FILE="./backup.log"
LOCK_FILE="/tmp/backup.lock"

# ============================
# Logging Function
# ============================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ============================
# Load Config
# ============================
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    log "ERROR: Missing config file!"
    exit 1
fi

# ============================
# Prevent Multiple Runs
# ============================
if [[ -f "$LOCK_FILE" ]]; then
    log "ERROR: Backup already running!"
    exit 1
fi
touch "$LOCK_FILE"

SOURCE_DIR="$1"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
BACKUP_NAME="backup-$TIMESTAMP.tar.gz"
BACKUP_PATH="$BACKUP_DEST/$BACKUP_NAME"

if [[ -z "$SOURCE_DIR" || ! -d "$SOURCE_DIR" ]]; then
    log "ERROR: Source folder not found ($SOURCE_DIR)"
    rm -f "$LOCK_FILE"
    exit 1
fi

mkdir -p "$BACKUP_DEST"

log "INFO: Starting backup of $SOURCE_DIR"

# ============================
# Build TAR Exclusions
# ============================
EXCLUDE_OPTS=()
IFS=',' read -ra patterns <<< "$EXCLUDE_PATTERNS"
for p in "${patterns[@]}"; do
    EXCLUDE_OPTS+=( --exclude="$p" )
done

# ============================
# Create Backup Archive ✅ FIXED TAR ORDER ✅
# ============================
tar -czf "$BACKUP_PATH" \
    "${EXCLUDE_OPTS[@]}" \
    -C "$(dirname "$SOURCE_DIR")" \
    "$(basename "$SOURCE_DIR")"

if [[ $? -ne 0 ]]; then
    log "ERROR: Backup failed!"
    rm -f "$BACKUP_PATH"
    rm -f "$LOCK_FILE"
    exit 1
fi

log "SUCCESS: Backup created: $BACKUP_PATH"

# ============================
# Checksum Generation
# ============================
CHECKSUM_FILE="$BACKUP_PATH.sha256"
sha256sum "$BACKUP_PATH" > "$CHECKSUM_FILE"
log "INFO: Checksum stored at: $CHECKSUM_FILE"

# ============================
# Verify Backup Integrity
# ============================
sha256sum -c "$CHECKSUM_FILE" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    log "ERROR: Backup corruption detected!"
else
    log "SUCCESS: Backup integrity confirmed ✅"
fi

# ============================
# Backup Rotation Policy
# Keep last N backups
# ============================
cd "$BACKUP_DEST"
BACKUPS_LIST=($(ls -t backup-*.tar.gz))
TOTAL_BACKUPS=${#BACKUPS_LIST[@]}

if (( TOTAL_BACKUPS > BACKUPS_KEEP )); then
    for (( i=BACKUPS_KEEP; i<TOTAL_BACKUPS; i++ )); do
        log "INFO: Removing old backup ${BACKUPS_LIST[$i]}"
        rm -f "${BACKUPS_LIST[$i]}" "${BACKUPS_LIST[$i]}.sha256"
    done
fi

log "INFO: Cleanup completed ✅"

# ============================
# Remove Lock File
# ============================
rm -f "$LOCK_FILE"

exit 0

