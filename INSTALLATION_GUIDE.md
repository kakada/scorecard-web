# Scorecard Web Application - Installation Guide

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [System Requirements](#system-requirements)
4. [Installation Steps](#installation-steps)
5. [Configuration](#configuration)
6. [Database Setup](#database-setup)
7. [Docker Deployment (Recommended)](#docker-deployment-recommended)
8. [Manual Deployment](#manual-deployment)
9. [Service Configuration](#service-configuration)
10. [Post-Deployment Verification](#post-deployment-verification)
11. [Troubleshooting](#troubleshooting)
12. [Maintenance and Operations](#maintenance-and-operations)

---

## Overview

The Scorecard Web is a community scorecard web application and backend API for the [scorecard_mobile](https://github.com/ilabsea/scorecard_mobile) application. This guide provides comprehensive instructions for deploying the application in a production environment.

**Technology Stack:**
- Ruby 3.1.3
- Rails 7.0.8
- PostgreSQL 12.4+
- Redis 7.2.3+
- Sidekiq (Background jobs)
- Docker & Docker Compose

---

## Prerequisites

### Required Software and Tools

1. **Docker Engine** (20.10+)
   - Installation: https://docs.docker.com/get-docker/

2. **Docker Compose** (1.29+)
   - Installation: https://docs.docker.com/compose/install/

3. **Git**
   - For cloning the repository

4. **Domain Name** (for production)
   - Configured DNS pointing to your server IP
   - Required for SSL/HTTPS setup

### Required Access and Credentials

Before starting, ensure you have:

1. **Server Access:**
   - SSH access to production server
   - Sudo/root privileges for installing dependencies

2. **Third-Party Services:**
   - Google OAuth2 credentials (if using Google Sign-In)
   - Sentry DSN (for error tracking)
   - AWS credentials (if using S3 for file storage)
   - Recaptcha keys (for form protection)

3. **Email Service:**
   - SMTP server credentials for sending emails

---

## System Requirements

### Minimum Hardware Requirements

**Production Server:**
- **CPU:** 2+ cores (4+ cores recommended)
- **RAM:** 4GB minimum (8GB+ recommended)
- **Storage:** 20GB minimum (SSD recommended)
- **Network:** Stable internet connection with fixed IP

### Software Dependencies

**Operating System:**
- Ubuntu 20.04 LTS or later (recommended)
- Debian 10+ or other Linux distributions
- macOS (for development/testing)

**Docker Images (automatically pulled):**
- `ruby:3.1.3`
- `postgres:12.4`
- `redis:7.2.3`
- `jwilder/nginx-proxy`
- `jrcs/letsencrypt-nginx-proxy-companion`

---

## Installation Steps

### Step 1: Server Preparation

```bash
# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git
```

### Step 2: Install Docker

```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify installation
docker --version

# Add current user to docker group (optional, to run docker without sudo)
sudo usermod -aG docker $USER
newgrp docker
```

### Step 3: Install Docker Compose

```bash
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

### Step 4: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/ilabsea/scorecard-web.git
cd scorecard-web

# Checkout the desired version/branch
git checkout main  # or specific version tag
```

---

## Configuration

> **⚠️ IMPORTANT SECURITY NOTICE**  
> Before proceeding with configuration, be aware that the repository's default `docker-compose.production.yml` uses trust-based database authentication (`POSTGRES_HOST_AUTH_METHOD=trust`), which is **not secure for production use**. This guide provides instructions for implementing secure password authentication. Always use password-protected database connections in production environments.

### Step 1: Create Environment Configuration File

```bash
# Copy the example environment file
cp app.env.example app.env
```

### Step 2: Configure Environment Variables

Edit the `app.env` file and configure the following critical settings:

#### Application Settings
```bash
APP_NAME=Community Scorecard
APP_SHORTCUT_NAME=CSC
APP_VERSION=0.0.1
HOST_URL=https://yourdomain.com  # Replace with your production domain
```

#### Database Configuration
```bash
DB_HOST=db
DB_USER=postgres
DB_PWD=your_secure_password  # REQUIRED for secure production deployment
                              # Leave empty only if using trust auth (NOT recommended)
DB_NAME=csc_web_production
```

> **⚠️ SECURITY WARNING:**  
> The default production Docker deployment uses `POSTGRES_HOST_AUTH_METHOD=trust` for database authentication, which allows connections without a password within the Docker network. **This is NOT recommended for production environments.**
> 
> **To implement secure database authentication:**
> 1. Set a strong password in the `DB_PWD` variable above
> 2. Update `docker-compose.production.yml`:
>    - Remove or comment out `POSTGRES_HOST_AUTH_METHOD=trust`
>    - Change `DATABASE_URL` to: `postgres://postgres:YOUR_PASSWORD@db/csc_web_production`
>    - Set `POSTGRES_PASSWORD=YOUR_PASSWORD` in the db service environment
> 3. Restart the database service for changes to take effect

#### Redis Configuration
```bash
REDIS_URL=redis://redis:6379
```

#### SMTP Configuration (Email)
```bash
SETTINGS__SMTP__ADDRESS=smtp.your-provider.com
SETTINGS__SMTP__DOMAIN=yourdomain.com
SETTINGS__SMTP__USER_NAME=your_smtp_username
SETTINGS__SMTP__PASSWORD=your_smtp_password
SETTINGS__SMTP__PORT=587
SETTINGS__SMTP__HOST=yourdomain.com
SETTINGS__SMTP__DEFAULT_FROM=noreply@yourdomain.com
MAILER_SENDER=noreply@yourdomain.com
```

#### Security and Authentication
```bash
# Google OAuth2 (optional)
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

# Recaptcha
RECAPTCHA_SITE_KEY=your_recaptcha_site_key
RECAPTCHA_SECRET_KEY=your_recaptcha_secret_key

# Sentry Error Tracking
SENTRY_DSN=https://your_sentry_dsn_url
```

#### AWS S3 Configuration (for file storage)
```bash
STORAGE_TYPE=S3  # Use 'Local' for local storage
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_NAME_OF_BUCKET=your_bucket_name
AWS_REGION=your_aws_region

# For database backups
AWS_NAME_OF_DB_BUCKET=your_db_backup_bucket
AWS_PATH_TO_DB_BACKUP=backups/
```



#### Rate Limiting (Rack Attack)
```bash
SAFELIST_IPS=127.0.0.1
BLOCKLIST_IPS=
THROTTLE_PERIOD_IN_SECOND=2
THROTTLE_REQUEST_LIMIT=5
```

#### Timezone
```bash
TIME_ZONE=Bangkok  # Set to your timezone
```

#### CORS Configuration
```bash
CORS_ALLOW_ORIGINS=yourdomain.com,www.yourdomain.com
```

#### Grafana Dashboard (Optional)
```bash
GF_DASHBOARD_URL=http://localhost:8000/login/generic_oauth
GF_DASHBOARD_ADMIN_USERNAME=admin
GF_DASHBOARD_ADMIN_PASSWORD=strong_password
GF_DASHBOARD_BASE_URL=http://localhost:8000
```

#### Download Limits
```bash
MAX_DOWNLOAD_SCORECARD_RECORD=1000
MAX_DOWNLOAD_RECORD=1000
```

#### GeoJSON Configuration
```bash
GEO_JSON_URL=https://yourdomain.com/provinces.json
```

### Step 3: Configure Production Docker Compose

Edit `docker-compose.production.yml` and update the following:

**⚠️ Default Configuration (Trust Authentication - INSECURE - DO NOT USE IN PRODUCTION):**
```yaml
services:
  db:
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust  # INSECURE - DO NOT USE IN PRODUCTION

  app:
    image: ilabsea/csc-web:0.0.1
    environment:
      - DATABASE_URL=postgres://postgres@db/csc_web_production  # INSECURE - No password authentication
      
      # ... other environment variables
```

**✅ Recommended Secure Configuration (USE THIS FOR PRODUCTION):**
```yaml
services:
  db:
    environment:
      - POSTGRES_PASSWORD=your_secure_database_password
      # Remove or comment out POSTGRES_HOST_AUTH_METHOD=trust

  app:
    image: ilabsea/csc-web:0.0.1  # Or build from source
    environment:
      # Database connection with password authentication
      - DATABASE_URL=postgres://postgres:your_secure_database_password@db/csc_web_production
      
      # SMTP Settings
      - SETTINGS__SMTP__ADDRESS=smtp.your-provider.com
      - SETTINGS__SMTP__DOMAIN=yourdomain.com
      - SETTINGS__SMTP__USER_NAME=your_smtp_username
      - SETTINGS__SMTP__PASSWORD=your_smtp_password
      - SETTINGS__SMTP__HOST=yourdomain.com
      - SETTINGS__SMTP__DEFAULT_FROM=noreply@yourdomain.com
      
      # Domain Configuration for SSL
      - VIRTUAL_HOST=yourdomain.com,www.yourdomain.com
      - VIRTUAL_PORT=80
      - LETSENCRYPT_HOST=yourdomain.com,www.yourdomain.com
      - LETSENCRYPT_EMAIL=admin@yourdomain.com
      
      # Application Info
      - APP_NAME=Community Scorecard
      - APP_SHORTCUT_NAME=CSC
      - APP_VERSION=0.0.1
```

> **💡 Recommendation:** Always use password authentication for production databases. The secure configuration shown above is strongly recommended.

---

## Database Setup

### Production Database Initialization

```bash
# Using Docker Compose
docker-compose -f docker-compose.production.yml run --rm app rake db:create RAILS_ENV=production
docker-compose -f docker-compose.production.yml run --rm app rake db:migrate RAILS_ENV=production
docker-compose -f docker-compose.production.yml run --rm app rake db:seed RAILS_ENV=production
```

### Database Migrations

```bash
# Run pending migrations
docker-compose -f docker-compose.production.yml run --rm app rake db:migrate RAILS_ENV=production
```

---

## Docker Deployment (Recommended)

### Option 1: Using Pre-built Docker Image

```bash
# Pull the latest image
docker pull ilabsea/csc-web:0.0.1

# Start all services
docker-compose -f docker-compose.production.yml up -d

# View logs
docker-compose -f docker-compose.production.yml logs -f
```

### Option 2: Building from Source

#### Step 1: Build the Docker Image

```bash
# Build production image
docker build -t ilabsea/csc-web:0.0.1 -f Dockerfile .
```

#### Step 2: Deploy Services

```bash
# Start all services in detached mode
docker-compose -f docker-compose.production.yml up -d

# Check service status
docker-compose -f docker-compose.production.yml ps

# View application logs
docker-compose -f docker-compose.production.yml logs -f app
```

### Production Services Overview

The production deployment includes:

1. **PostgreSQL Database** (`db`)
   - Persistent data storage with volume mounting
   - Automatic backups (configured with `whenever` gem)

2. **Application Server** (`app`)
   - Rails application with Puma web server
   - Serves on port 80 internally

3. **Nginx Reverse Proxy** (`nginx-proxy`)
   - Handles incoming HTTP/HTTPS traffic
   - Automatic SSL certificate management
   - Exposes ports 80 and 443

4. **Let's Encrypt Companion** (`letsencrypt`)
   - Automatic SSL certificate generation and renewal
   - Works with nginx-proxy

> **Note:** The basic production docker-compose configuration includes only the four services listed above (PostgreSQL, Application Server, Nginx Reverse Proxy, and Let's Encrypt). If your application requires Redis (for caching and Sidekiq queue) or background job processing with Sidekiq, you'll need to either:
> - Add these services to your `docker-compose.production.yml`, or
> - Set up external Redis and Sidekiq services separately
> 
> For development, these services are included in `docker-compose.yml`.

---

## Manual Deployment

If you prefer not to use Docker, follow these steps for manual deployment:

### Step 1: Install System Dependencies

```bash
# Install Ruby dependencies
sudo apt-get install -y \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libpq-dev \
    nodejs \
    yarn \
    postgresql-12 \
    postgresql-contrib \
    redis-server

# Install rbenv or RVM for Ruby version management
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Install Ruby 3.1.3
rbenv install 3.1.3
rbenv global 3.1.3

# Verify Ruby installation
ruby -v
```

### Step 2: Install Application Dependencies

```bash
# Install Bundler
gem install bundler:2.1.4

# Install gems
bundle config set deployment 'true'
bundle install --jobs 10
```

### Step 3: Setup PostgreSQL Database

```bash
# Create database user
sudo -u postgres createuser -s scorecard_user
sudo -u postgres psql -c "ALTER USER scorecard_user WITH PASSWORD 'your_password';"

# Create database
sudo -u postgres createdb -O scorecard_user csc_web_production

# Run migrations
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake db:seed
```

### Step 4: Compile Assets

```bash
# Precompile assets for production
RAILS_ENV=production bundle exec rake assets:precompile
```

### Step 5: Setup Systemd Services

Create `/etc/systemd/system/scorecard-web.service`:

```ini
[Unit]
Description=Scorecard Web Application
After=network.target

[Service]
Type=simple
User=deployer
WorkingDirectory=/var/www/scorecard-web
Environment="RAILS_ENV=production"
Environment="RACK_ENV=production"
ExecStart=/usr/local/bin/bundle exec puma -C config/puma.rb
Restart=always

[Install]
WantedBy=multi-user.target
```

Create `/etc/systemd/system/scorecard-sidekiq.service`:

```ini
[Unit]
Description=Scorecard Sidekiq Worker
After=network.target

[Service]
Type=simple
User=deployer
WorkingDirectory=/var/www/scorecard-web
Environment="RAILS_ENV=production"
ExecStart=/usr/local/bin/bundle exec sidekiq -C config/sidekiq.yml
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start services:

```bash
sudo systemctl daemon-reload
sudo systemctl enable scorecard-web
sudo systemctl enable scorecard-sidekiq
sudo systemctl start scorecard-web
sudo systemctl start scorecard-sidekiq
```

### Step 6: Setup Nginx

Install and configure Nginx:

```bash
sudo apt-get install -y nginx

# Create Nginx configuration
sudo nano /etc/nginx/sites-available/scorecard-web
```

Nginx configuration example:

```nginx
upstream scorecard_app {
  server localhost:3000;
}

server {
  listen 80;
  server_name yourdomain.com www.yourdomain.com;
  
  root /var/www/scorecard-web/public;
  
  location / {
    try_files $uri @app;
  }
  
  location @app {
    proxy_pass http://scorecard_app;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
  
  client_max_body_size 100M;
  keepalive_timeout 10;
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/scorecard-web /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Step 7: Setup SSL with Certbot

```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

---

## Service Configuration

> **Important:** The basic `docker-compose.production.yml` does not include Redis or Sidekiq services. If your application requires these services, you need to add them to the production configuration or set them up as external services. The development `docker-compose.yml` includes these services as reference.

### Sidekiq (Background Jobs)

Sidekiq is used for processing background jobs. Configuration is in `config/sidekiq.yml`.

**Key Workers:**
- Email delivery
- Activity log cleaning

**Note:** Additional workers may be available depending on the features enabled in your application (e.g., data processing, notifications, etc.).

**To enable Sidekiq in production:**
1. Add Redis and Sidekiq services to `docker-compose.production.yml` (refer to `docker-compose.yml` for service definitions)
2. Ensure `REDIS_URL` environment variable is properly configured
3. Start the services with your production deployment

**Monitor Sidekiq:**
```bash
# Docker deployment (if Sidekiq service is added)
docker-compose -f docker-compose.production.yml logs -f sidekiq

# Manual deployment
sudo systemctl status scorecard-sidekiq
```

### Cron Jobs (Whenever Gem)

The application uses the `whenever` gem for scheduled tasks:

```bash
# View scheduled tasks
bundle exec whenever

# Update crontab
bundle exec whenever --update-crontab

# Clear crontab
bundle exec whenever --clear-crontab
```

**Scheduled Tasks:**
- Daily data backup (24:00)
- Sample data loading (if enabled)
- Activity log cleaning

### Redis Configuration

Redis is used for:
- Sidekiq job queue
- Session storage
- Caching

**Note:** Redis is not included in the basic `docker-compose.production.yml`. To use Redis in production:

1. **Add Redis service to `docker-compose.production.yml`:**
   ```yaml
   redis:
     image: redis:7.2.3
     restart: unless-stopped
   ```

2. **Configure the connection string:**
   - Docker: `redis://redis:6379`
   - Manual deployment: `redis://localhost:6379`

3. **Set environment variable in app.env:**
   ```bash
   REDIS_URL=redis://redis:6379
   ```

Alternatively, use an external managed Redis service and update the `REDIS_URL` accordingly.

---

## Post-Deployment Verification

### Step 1: Check Service Status

```bash
# Docker deployment
docker-compose -f docker-compose.production.yml ps

# All services should show "Up" status
```

### Step 2: Access the Application

```bash
# Via web browser
https://yourdomain.com

# Check application health endpoint (if available)
curl https://yourdomain.com/health
```

### Step 3: Verify Database Connection

```bash
# Docker deployment
docker-compose -f docker-compose.production.yml run --rm app rails console -e production

# In Rails console:
> ActiveRecord::Base.connection.execute("SELECT 1")
# Should return: #<PG::Result:0x... >
```

### Step 4: Test User Authentication

1. Navigate to the sign-up page
2. Create a test user account
3. Verify email functionality
4. Test sign-in process
5. Test Google OAuth (if configured)

### Step 5: Check Background Jobs

**Note:** This step applies only if you have configured Redis and Sidekiq services in your production setup.

```bash
# Access Sidekiq Web UI (if configured)
https://yourdomain.com/sidekiq

# Check Sidekiq logs (if service added to docker-compose.production.yml)
docker-compose -f docker-compose.production.yml logs sidekiq
```

### Step 6: Verify File Uploads

1. Log in to the application
2. Upload a test file
3. Verify file is stored correctly (local or S3)

### Step 7: Monitor Logs

```bash
# Application logs
docker-compose -f docker-compose.production.yml logs -f app

# Database logs
docker-compose -f docker-compose.production.yml logs -f db

# All service logs
docker-compose -f docker-compose.production.yml logs -f
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Database Connection Issues

**Problem:** Application cannot connect to database

**Solutions:**
```bash
# Check database container is running
docker-compose -f docker-compose.production.yml ps db

# Check database logs
docker-compose -f docker-compose.production.yml logs db

# Verify database connection format
# The production setup uses trust authentication, so no password in DATABASE_URL
# Expected format: postgres://postgres@db/csc_web_production

# Test database connection
docker-compose -f docker-compose.production.yml exec db psql -U postgres -c "SELECT 1"
```

#### 2. SSL Certificate Issues

**Problem:** SSL certificate not generating or invalid

**Solutions:**
```bash
# Check Let's Encrypt logs
docker-compose -f docker-compose.production.yml logs letsencrypt

# Verify DNS is correctly configured
nslookup yourdomain.com

# Ensure ports 80 and 443 are open
sudo ufw status
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Restart Let's Encrypt companion
docker-compose -f docker-compose.production.yml restart letsencrypt
```

#### 3. Asset Compilation Errors

**Problem:** Assets not loading or 404 errors

**Solutions:**
```bash
# Rebuild image with assets
docker-compose -f docker-compose.production.yml build --no-cache app

# Or manually precompile
docker-compose -f docker-compose.production.yml run --rm app rake assets:precompile RAILS_ENV=production
```

#### 4. Email Not Sending

**Problem:** Emails not being delivered

**Solutions:**
```bash
# Check SMTP settings in app.env
# Verify credentials with SMTP provider

# Test email in Rails console
docker-compose -f docker-compose.production.yml run --rm app rails console -e production

# In console:
> ActionMailer::Base.mail(from: 'test@example.com', to: 'recipient@example.com', subject: 'Test', body: 'Test email').deliver_now

# Check Sidekiq for email jobs
# Access Sidekiq Web UI at https://yourdomain.com/sidekiq
```

#### 5. Sidekiq Jobs Not Processing

**Problem:** Background jobs stuck or not executing

**Note:** This applies only if you have added Redis and Sidekiq services to your production setup.

**Solutions:**
```bash
# Check Sidekiq container status (if service added to docker-compose.production.yml)
docker-compose -f docker-compose.production.yml ps sidekiq

# Check Sidekiq logs
docker-compose -f docker-compose.production.yml logs sidekiq

# Verify Redis connection (if service added to docker-compose.production.yml)
docker-compose -f docker-compose.production.yml exec redis redis-cli ping
# Should return: PONG

# Restart Sidekiq
docker-compose -f docker-compose.production.yml restart sidekiq

# For manual deployment
sudo systemctl status scorecard-sidekiq
sudo systemctl restart scorecard-sidekiq
```

#### 6. High Memory Usage

**Problem:** Server running out of memory

**Solutions:**
```bash
# Check container resource usage
docker stats

# Adjust Sidekiq concurrency in config/sidekiq.yml
# Reduce production: :concurrency from 20 to lower value

# Add swap space (if necessary)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make swap permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

#### 7. Permission Issues

**Problem:** File permission errors

**Solutions:**
```bash
# Fix ownership of application files
sudo chown -R $USER:$USER /path/to/scorecard-web

# For Docker volumes
docker-compose -f docker-compose.production.yml down
sudo chown -R $USER:$USER ./storage ./log ./tmp
docker-compose -f docker-compose.production.yml up -d
```

#### 8. Port Already in Use

**Problem:** Cannot bind to port 80 or 443

**Solutions:**
```bash
# Check what's using the port
sudo lsof -i :80
sudo lsof -i :443

# Stop conflicting service
sudo systemctl stop apache2  # or nginx, if not using Docker's nginx

# Or change port mapping in docker-compose.production.yml
```

#### 9. Cannot Access Application

**Problem:** 502 Bad Gateway or connection refused

**Solutions:**
```bash
# Check all containers are running
docker-compose -f docker-compose.production.yml ps

# Check application logs for errors
docker-compose -f docker-compose.production.yml logs app

# Restart all services
docker-compose -f docker-compose.production.yml restart

# Or full restart
docker-compose -f docker-compose.production.yml down
docker-compose -f docker-compose.production.yml up -d
```

### Getting Help

If issues persist:

1. **Check Logs:** Review all service logs for error messages
2. **Sentry:** Check Sentry dashboard for application errors
3. **Documentation:** Review Rails and Docker documentation
4. **Community:** Open an issue on GitHub repository
5. **Support:** Contact development team at support@digital-csc.org

---

## Maintenance and Operations

### Regular Maintenance Tasks

#### Daily Tasks

1. **Monitor Application Health:**
   ```bash
   docker-compose -f docker-compose.production.yml ps
   curl https://yourdomain.com/health
   ```

2. **Check Disk Space:**
   ```bash
   df -h
   docker system df
   ```

3. **Review Error Logs:**
   - Check Sentry dashboard
   - Review application logs

#### Weekly Tasks

1. **Database Backups:**
   ```bash
   # Backups run automatically via cron
   # Verify backup files exist
   ls -lh /path/to/backups/
   ```

2. **Clean Up Docker:**
   ```bash
   # Remove unused images
   docker image prune -a
   
   # Remove unused volumes (be careful!)
   docker volume prune
   ```

3. **Update Dependencies:**
   ```bash
   # Check for security updates
   docker-compose -f docker-compose.production.yml run --rm app bundle audit
   ```

#### Monthly Tasks

1. **Update Application:**
   ```bash
   # Pull latest changes
   git fetch origin
   git checkout tags/v1.x.x  # or latest stable version
   
   # Rebuild and redeploy
   docker-compose -f docker-compose.production.yml build
   docker-compose -f docker-compose.production.yml up -d
   ```

2. **Certificate Renewal:**
   - Let's Encrypt certificates auto-renew
   - Verify renewal: `docker-compose -f docker-compose.production.yml logs letsencrypt`

3. **Performance Review:**
   - Check response times
   - Review Grafana dashboards (if configured)
   - Optimize slow queries

### Backup and Recovery

#### Database Backup

**Automated Backup (configured in schedule.rb):**
```bash
# Runs daily at 24:00
# Check crontab
docker-compose -f docker-compose.production.yml exec app bundle exec whenever
```

**Manual Backup:**
```bash
# Backup to file
docker-compose -f docker-compose.production.yml exec db pg_dump -U postgres csc_web_production > backup_$(date +%Y%m%d).sql

# Backup to S3 (if configured)
docker-compose -f docker-compose.production.yml run --rm app backup perform -t db_backup
```

#### Database Restore

```bash
# Restore from backup file
docker-compose -f docker-compose.production.yml exec -T db psql -U postgres csc_web_production < backup_20231201.sql

# Or restore from S3
docker-compose -f docker-compose.production.yml run --rm app backup restore -t db_backup
```

#### Full System Backup

```bash
# Backup volumes
docker-compose -f docker-compose.production.yml down
sudo tar -czf scorecard_backup_$(date +%Y%m%d).tar.gz \
    /var/lib/docker/volumes/scorecard-web_db \
    /var/lib/docker/volumes/scorecard-web_attachment \
    /path/to/scorecard-web/app.env

# Restart services
docker-compose -f docker-compose.production.yml up -d
```

### Scaling Considerations

#### Horizontal Scaling

To handle increased load:

1. **Add More Application Instances:**
   ```yaml
   # In docker-compose.production.yml
   app:
     deploy:
       replicas: 3
   ```

2. **Load Balancing:**
   - Nginx-proxy handles automatic load balancing
   - Consider external load balancer for multiple servers

3. **Database:**
   - Use PostgreSQL replication
   - Consider managed database service (RDS, etc.)

#### Vertical Scaling

Increase resources for existing services:

```yaml
# In docker-compose.production.yml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          cpus: '1.0'
          memory: 2G
```

### Monitoring and Logging

#### Application Monitoring

1. **Sentry:** Real-time error tracking
   - Configure SENTRY_DSN in app.env
   - Access: https://sentry.io

2. **Grafana:** Performance dashboards
   - Configure GF_* variables in app.env
   - Access: Configured GF_DASHBOARD_URL

3. **Sidekiq Web UI:**
   - Monitor background jobs (if Sidekiq is configured)
   - Access: https://yourdomain.com/sidekiq

#### Log Management

```bash
# View real-time logs
docker-compose -f docker-compose.production.yml logs -f

# View specific service logs
docker-compose -f docker-compose.production.yml logs -f app

# Export logs
docker-compose -f docker-compose.production.yml logs > logs_$(date +%Y%m%d).txt

# Configure log rotation in docker-compose.production.yml
logging:
  driver: json-file
  options:
    max-size: 10m
    max-file: '5'
```

### Security Best Practices

1. **Database Security (CRITICAL):**
   ```bash
   # ALWAYS use password authentication in production
   # Edit docker-compose.production.yml:
   
   # In db service:
   environment:
     - POSTGRES_PASSWORD=your_strong_password
     # Remove: POSTGRES_HOST_AUTH_METHOD=trust
   
   # In app service:
   environment:
     - DATABASE_URL=postgres://postgres:your_strong_password@db/csc_web_production
   ```
   
   **Why this matters:** Trust authentication allows any container in the Docker network to access your database without credentials, which is a critical security vulnerability.

2. **Keep Software Updated:**
   - Regularly update Docker images
   - Apply security patches promptly

2. **Strong Passwords:**
   - Use strong, unique passwords
   - Rotate credentials regularly

3. **Firewall Configuration:**
   ```bash
   # Enable UFW
   sudo ufw enable
   sudo ufw allow 22/tcp   # SSH
   sudo ufw allow 80/tcp   # HTTP
   sudo ufw allow 443/tcp  # HTTPS
   ```

4. **SSL/TLS:**
   - Always use HTTPS in production
   - Keep SSL certificates up to date

5. **Access Control:**
   - Limit SSH access
   - Use SSH keys instead of passwords
   - Implement role-based access control in application

6. **Regular Audits:**
   ```bash
   # Check for security vulnerabilities
   docker-compose -f docker-compose.production.yml run --rm app bundle audit
   ```

### Performance Optimization

1. **Database Optimization:**
   ```bash
   # Analyze and vacuum database
   docker-compose -f docker-compose.production.yml exec db psql -U postgres csc_web_production -c "VACUUM ANALYZE;"
   ```

2. **Asset Caching:**
   - CDN for static assets
   - Configure browser caching headers

3. **Query Optimization:**
   - Monitor slow queries
   - Add appropriate database indexes

4. **Caching Strategy:**
   - Use Redis for caching
   - Implement fragment caching

---

## Additional Resources

### Documentation Links

- **Rails Guides:** https://guides.rubyonrails.org/
- **Docker Documentation:** https://docs.docker.com/
- **PostgreSQL Documentation:** https://www.postgresql.org/docs/
- **Redis Documentation:** https://redis.io/documentation
- **Sidekiq Documentation:** https://github.com/sidekiq/sidekiq/wiki

### Project Resources

- **GitHub Repository:** https://github.com/ilabsea/scorecard-web
- **Mobile App Repository:** https://github.com/ilabsea/scorecard_mobile
- **Issue Tracker:** https://github.com/ilabsea/scorecard-web/issues
- **Play Store:** https://play.google.com/store/apps/details?id=org.instedd.ilabsea.community_scorecard

### Support

- **Email:** support@digital-csc.org
- **Development Team:** Create an issue on GitHub

---

## Appendix

### A. Environment Variables Reference

Complete list of all environment variables with descriptions:

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `APP_NAME` | Application name | Yes | Community Scorecard |
| `APP_VERSION` | Application version | Yes | 0.0.1 |
| `HOST_URL` | Public application URL | Yes | - |
| `DB_HOST` | Database host | Yes | db |
| `DB_USER` | Database username | Yes | postgres |
| `DB_PWD` | Database password | Yes | - |
| `DB_NAME` | Database name | Yes | csc_web_production |
| `REDIS_URL` | Redis connection URL | Yes | redis://redis:6379 |
| `SENTRY_DSN` | Sentry error tracking URL | No | - |
| `GOOGLE_CLIENT_ID` | Google OAuth client ID | No | - |
| `GOOGLE_CLIENT_SECRET` | Google OAuth secret | No | - |
| `RECAPTCHA_SITE_KEY` | Recaptcha site key | No | - |
| `RECAPTCHA_SECRET_KEY` | Recaptcha secret key | No | - |
| `AWS_ACCESS_KEY_ID` | AWS access key | No | - |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | No | - |
| `TIME_ZONE` | Application timezone | Yes | Bangkok |

### B. Port Reference

| Service | Internal Port | External Port | Description |
|---------|---------------|---------------|-------------|
| Application | 80 | - | Rails app (via proxy) |
| Nginx Proxy | 80, 443 | 80, 443 | HTTP/HTTPS traffic |
| PostgreSQL | 5432 | - | Database |
| Redis | 6379 | - | Cache and jobs |
| Sidekiq | - | - | Background jobs |

### C. Directory Structure

```
scorecard-web/
├── app/              # Application code
├── config/           # Configuration files
├── db/               # Database files
├── docker/           # Docker configurations
├── lib/              # Custom libraries and tasks
├── public/           # Public assets
├── spec/             # Test files
├── vendor/           # Third-party assets
├── Dockerfile        # Production Dockerfile
├── Dockerfile.dev    # Development Dockerfile
├── docker-compose.yml              # Development compose
├── docker-compose.production.yml   # Production compose
├── app.env.example   # Environment template
├── Gemfile           # Ruby dependencies
└── README.md         # Project README
```

---

**Last Updated:** 2025-10-20  
**Version:** 1.0  
**Maintainer:** Scorecard Web Development Team
