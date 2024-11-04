#!/bin/bash

# List of source directories to back up
SOURCE_DIRS=(
    "/var/www"
    "/var/vmail"
)

# Remote server details
REMOTE_USER="root"
REMOTE_SERVER="10.142.1.2"
REMOTE_BACKUP_DIR="/run/media/monitor/Transcend/rsync/folder_name"

# Date format for organizing backups
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Ensure the remote backup directory exists
ssh "$REMOTE_USER@$REMOTE_SERVER" "mkdir -p $REMOTE_BACKUP_DIR"

# Loop through each source directory and back it up
for SOURCE_DIR in "${SOURCE_DIRS[@]}"; do
    echo "Backing up $SOURCE_DIR to remote server..."

    # Use rsync to copy the folder to the remote server
    rsync -avz --delete "$SOURCE_DIR/" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_BACKUP_DIR/$(basename "$SOURCE_DIR")_$DATE/"
done

echo "Backup of multiple folders completed successfully."
