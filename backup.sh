#!/bin/bash

# Variables
BACKUP_DIR="/root/morent-cms/backup"
SQL_BACKUP_FILE="$BACKUP_DIR/database.sql"
UPLOADS_BACKUP_DIR="$BACKUP_DIR/uploads"
ARCHIVE_FILE="$BACKUP_DIR/uploads.tar.gz"

CONTAINER_NAME_DB="morent-cms-database-1"
CONTAINER_NAME_DIRECTUS="morent-cms-directus-1"

# Step 1: Ensure backup directory exists
echo "Ensuring backup directory exists..."
mkdir -p $BACKUP_DIR

# Step 2: Export the database
echo "Exporting the database..."
docker exec $CONTAINER_NAME_DB /usr/bin/mariadb-dump -u${DB_USER} -p${DB_PASSWORD} directus > $SQL_BACKUP_FILE
if [ $? -ne 0 ]; then
  echo "Database export failed."
  exit 1
fi
echo "Database exported successfully to $SQL_BACKUP_FILE."

# Step 3: Copy media files from the container
echo "Copying media files from container..."
docker cp $CONTAINER_NAME_DIRECTUS:/directus/uploads $UPLOADS_BACKUP_DIR
if [ $? -ne 0 ]; then
  echo "Failed to copy media files."
  exit 1
fi
echo "Media files copied successfully to $UPLOADS_BACKUP_DIR."

# Step 4: Compress the uploads directory
echo "Compressing the uploads directory..."
tar -czf $ARCHIVE_FILE -C $BACKUP_DIR uploads
if [ $? -ne 0 ]; then
  echo "Failed to create archive."
  exit 1
fi
echo "Uploads directory compressed to $ARCHIVE_FILE."

# Step 5: Clean up uncompressed uploads directory
echo "Cleaning up uncompressed uploads directory..."
rm -rf $UPLOADS_BACKUP_DIR
echo "Cleanup complete."

# Step 6: Stage the backup files for Git
echo "Staging backup files for Git..."
git add $SQL_BACKUP_FILE $ARCHIVE_FILE
if [ $? -ne 0 ]; then
  echo "Failed to stage backup files for Git."
  exit 1
fi
echo "Backup files staged successfully."

# Step 7: Commit the backup
echo "Committing the backup..."
git commit -m "Backup on $(date +%Y-%m-%d)"
if [ $? -ne 0 ]; then
  echo "Failed to commit backup files."
  exit 1
fi
echo "Backup committed successfully."

# Step 8: Push the changes to the repository
echo "Pushing changes to the repository..."
git push
if [ $? -ne 0 ]; then
  echo "Failed to push changes to the repository."
  exit 1
fi
echo "Backup pushed to repository successfully."

echo "Backup process completed."
