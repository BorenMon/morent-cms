# Headless CMS with Directus for MORENT

This repository sets up a Headless CMS powered by [Directus](https://directus.io/), using Docker for container orchestration. The configuration includes a MariaDB database, Redis caching, and Directus application.

## Features

- **Directus**: Fully-featured headless CMS for managing content.
- **MariaDB**: Database for content storage.
- **Redis**: Cache layer for improved performance.
- **Docker Compose**: Simplifies setup and orchestration.

## Prerequisites

Ensure the following are installed:
- Docker
- Docker Compose

## Setup

1. Clone the Repository
    ```bash
    git clone https://github.com/BorenMon/morent-cms.git
    cd morent-cms 
    ```

2. Configure Environment Variables
    - Copy `.env.example` to `.env`:
        ```bash
        cp .env.example .env  
        ```
    - Fill in required values in the `.env` file:
        ```env
        DB_USER=<your_database_user>  
        DB_PASSWORD=<your_database_password>  
        SECRET=<your_secret_key>  
        ADMIN_EMAIL=<your_admin_email>  
        ADMIN_PASSWORD=<your_admin_password>  
        PUBLIC_URL=<your_directus_url>  
        ```

3. Start the Services

    Run the following command to start all services:
    ```bash
    docker compose up -d
    ```

## Services Overview

- Directus: Available at http://localhost:8055
- MariaDB: Running on port 3306

## Volumes

The following Docker volumes are used for data persistence:

- `directus-uploads`: Stores uploaded media files.
- `directus-extensions`: Stores custom extensions for Directus.
- `mariadb-data`: Stores database data.

## Notes

- Directus requires the `ADMIN_EMAIL` and `ADMIN_PASSWORD` to create the first admin user.
- For production deployment, ensure `PUBLIC_URL` is set to the accessible URL of your Directus instance.