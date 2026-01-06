#!/bin/sh
PATH=/usr/bin:/bin

# CONFIG
PGUSER=sistemascead
PGDATABASE=sistemascead
CONTAINER_NAME=sistemascead-database
BACKUP_ROOT="/media/truenas/backups/sistemascead-database"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d)"
BACKUP_FILE="$BACKUP_DIR/sistemascead-$(date +%H).sql.gz"
LOG_FILE="$BACKUP_ROOT/backup-$(date +%Y%m%d).log"
RETENTION_DAYS=120

mkdir -p "$BACKUP_DIR"

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[Backup] $(date +'%F %T') Container $CONTAINER_NAME não está em execução." >> "$LOG_FILE"
    exit 1
fi

echo "[Backup] $(date +'%F %T') Iniciando backup: $BACKUP_FILE" >> "$LOG_FILE"
docker exec "$CONTAINER_NAME" pg_dump -U "$PGUSER" "$PGDATABASE" | gzip > "$BACKUP_FILE"
BACKUP_SIZE_BYTES=$(stat -c %s "$BACKUP_FILE" 2>/dev/null)
BACKUP_SIZE_MB=$(awk "BEGIN {mb=$BACKUP_SIZE_BYTES/1048576; printf \"%.2f\", mb}" | sed 's/\./,/')
echo "[Backup] $(date +'%F %T') Backup finalizado (${BACKUP_SIZE_MB}MB)." >> "$LOG_FILE"

echo "[Backup] $(date +'%F %T') Apagando backups com mais de $RETENTION_DAYS dias..." >> "$LOG_FILE"
find $BACKUP_ROOT -mindepth 1 -maxdepth 1 -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \;
find $BACKUP_ROOT -maxdepth 1 -name "backup-*.log" -mtime +$RETENTION_DAYS -delete
