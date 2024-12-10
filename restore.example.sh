#!/bin/bash

# Define paths
BACKUP_DIR="backup"
SQL_BACKUP_FILE="$BACKUP_DIR/database.sql"
MEDIA_ARCHIVE="$BACKUP_DIR/uploads.tar.gz"
EXTRACTED_MEDIA_DIR="$BACKUP_DIR/uploads"

# Variables
CONTAINER_NAME_DB="your-database-container-name" # Replace with the name of your database container
CONTAINER_NAME_DIRECTUS="your-directus-container-name" # Replace with the name of your Directus container
# Load environment variables
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Check if required backup files exist
if [[ ! -f "$SQL_BACKUP_FILE" ]]; then
    echo "Error: Database backup file ($SQL_BACKUP_FILE) not found."
    exit 1
fi

if [[ ! -f "$MEDIA_ARCHIVE" ]]; then
    echo "Error: Media archive file ($MEDIA_ARCHIVE) not found."
    exit 1
fi

# Restore Database
echo "Restoring database..."
docker exec -i $CONTAINER_NAME_DB mariadb -u${DB_USER} -p${DB_PASSWORD} directus < "$SQL_BACKUP_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to restore database."
    exit 1
fi

# Extract Media Files (flattening directory structure)
echo "Extracting media files..."
rm -rf "$EXTRACTED_MEDIA_DIR"  # Ensure the extraction directory is clean
mkdir -p "$EXTRACTED_MEDIA_DIR"
tar --strip-components=1 -xzf "$MEDIA_ARCHIVE" -C "$EXTRACTED_MEDIA_DIR"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to extract media files."
    exit 1
fi

# Restore Media Files
echo "Restoring media files..."
docker cp "$EXTRACTED_MEDIA_DIR/." $CONTAINER_NAME_DIRECTUS:/directus/uploads
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to restore media files."
    exit 1
fi

# Restart Directus Service
echo "Restarting Directus service..."
docker compose restart directus
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to restart Directus service."
    exit 1
fi

echo "Restoration complete!"