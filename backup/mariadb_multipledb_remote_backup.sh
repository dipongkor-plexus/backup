#!/bin/bash

# Local backup directory and database details
LOCAL_BACKUP_DIR="/backup"
DB_USER="root"
DB_PASS='password'
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Remote server details
REMOTE_USER="root"
REMOTE_SERVER="10.142.1.2"
REMOTE_BACKUP_DIR="/run/media/monitor/Transcend/rsync/14406"

# List of databases to back up
DATABASES=("client_isperp_db" "client_isperpuser_db" "demoradius" "erp_isp_db" "isperp_db" "isperp_db_users" "shadhin_erp_db" "testradius")

# Create local backup directory if it doesn't exist
mkdir -p "$LOCAL_BACKUP_DIR"

# Loop through each database and back it up
for DB_NAME in "${DATABASES[@]}"; do
    # Create a backup of each database
    mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$LOCAL_BACKUP_DIR/${DB_NAME}_$DATE.sql"

    # Transfer each backup to the remote server
    scp "$LOCAL_BACKUP_DIR/${DB_NAME}_$DATE.sql" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_BACKUP_DIR"
done

# Optional: Delete local backups older than 7 days
find "$LOCAL_BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm {} \;

# Optional: Delete remote backups older than 30 days
ssh "$REMOTE_USER@$REMOTE_SERVER" "find $REMOTE_BACKUP_DIR -type f -name '*.sql' -mtime +30 -exec rm {} \;"
