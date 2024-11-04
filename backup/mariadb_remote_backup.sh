#!/bin/bash

# Local backup directory and database details
LOCAL_BACKUP_DIR="/etc/backup"
DB_USER="root"
DB_PASS='password'
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Remote server details
REMOTE_USER="root"
REMOTE_SERVER="10.142.1.2"
REMOTE_BACKUP_DIR="/run/media/monitor/Transcend/rsync/14408"

# Create the local backup directory if it doesn't exist
mkdir -p "$LOCAL_BACKUP_DIR"

# Create the database backup
mysqldump -u $DB_USER -p$DB_PASS --all-databases > "$LOCAL_BACKUP_DIR/all_databases_$DATE.sql"

# Transfer the backup to the remote server
scp "$LOCAL_BACKUP_DIR/all_databases_$DATE.sql" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_BACKUP_DIR"

# Optional: Delete local backups older than 7 days
find "$LOCAL_BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm {} \;

# Optional: Delete remote backups older than 30 days
ssh "$REMOTE_USER@$REMOTE_SERVER" "find $REMOTE_BACKUP_DIR -type f -name '*.sql' -mtime +30 -exec rm {} \;"
