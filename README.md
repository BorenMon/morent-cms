
# Headless CMS with Directus for MORENT

This repository sets up a Headless CMS powered by [Directus](https://directus.io/), using Docker for container orchestration. The configuration includes a MariaDB database, Redis caching, and the Directus application.

## Features

- **Directus**: Fully-featured headless CMS for managing content.
- **MariaDB**: Database for content storage.
- **Redis**: Cache layer for improved performance.
- **Docker Compose**: Simplifies setup and orchestration.
- **Backup & Restore**: Automates content and media backups with provided scripts.

---

## Prerequisites

Ensure the following are installed:
- Docker
- Docker Compose

---

## Setup

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/BorenMon/morent-cms.git
   cd morent-cms
   ```

2. **Configure Environment Variables**  
   - Copy `.env.example` to `.env`:  
     ```bash
     cp .env.example .env
     ```  
   - Fill in the required values in the `.env` file:  
     ```env
     DB_USER=<your_database_user>
     DB_PASSWORD=<your_database_password>
     SECRET=<your_secret_key>
     ADMIN_EMAIL=<your_admin_email>
     ADMIN_PASSWORD=<your_admin_password>
     PUBLIC_URL=<your_directus_url>
     ```

3. **Start the Services**  
   Run the following command to start all services:  
   ```bash
   docker compose up -d
   ```

4. **Access Directus**  
   - Directus will be available at: `http://localhost:8055`

---

## Backup & Restore

This repository includes scripts for backing up and restoring your database and media files.

### Setup Backup & Restore Scripts

1. Copy and modify the example scripts:
   - For **backup**:
     ```bash
     cp backup.example.sh backup.sh
     ```
   - For **restore**:
     ```bash
     cp restore.example.sh restore.sh
     ```

2. Open the `backup.sh` and `restore.sh` files in a text editor and verify the paths and container names match your setup.

3. Make the scripts executable:
   ```bash
   chmod +x backup.sh restore.sh
   ```

---

### Backup Process

The `backup.sh` script performs the following tasks:
1. Exports the Directus database.
2. Compresses the media uploads directory.
3. Cleans up temporary files.
4. Stages the backup files for Git, commits them, and pushes to the repository.

Run the backup script:
```bash
./backup.sh
```

### Restore Process

The `restore.sh` script performs the following tasks:
1. Restores the Directus database from the backup file.
2. Extracts and restores the media uploads directory.
3. Restarts the Directus service to apply changes.

Run the restore script:
```bash
./restore.sh
```

---

## Notes

- **Database User and Password**: The backup and restore scripts use values from the `.env` file for `DB_USER` and `DB_PASSWORD`.
- **Backup Location**: Backups are stored in the `backup` directory under the project root.
- **Git Tracking**: Backup files (`database.sql` and `uploads.tar.gz`) are staged, committed, and pushed to the Git repository during the backup process.

---

## Volumes

The following Docker volumes are used for data persistence:
- `directus-uploads`: Stores uploaded media files.
- `directus-extensions`: Stores custom extensions for Directus.
- `mariadb-data`: Stores database data.

---

## Important

- Make sure to exclude sensitive files or backups from public repositories unless they are secured.
- For production deployments, ensure `PUBLIC_URL` is set to the accessible URL of your Directus instance.
