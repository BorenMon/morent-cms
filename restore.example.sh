#!/bin/bash  

# Restore Database  
echo "Restoring database..."  
docker exec -i <database_container_name> mysql -u<DB_USER> -p<DB_PASSWORD> directus < data/database.sql  

# Restore Media Files  
echo "Restoring media files..."  
docker cp data/uploads <directus_container_name>:/directus/uploads  

# Restart Directus Service  
echo "Restarting Directus service..."  
docker compose restart directus

echo "Restoration complete!"  
