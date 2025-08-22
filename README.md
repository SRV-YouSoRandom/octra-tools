# Octra Wallet Generator - Docker Setup

This repository contains Docker configuration to run the Octra Wallet Generator in a containerized environment using a non-root user for enhanced security.

## 🔒 Security Features

- Runs as non-root user (`octra`) inside the container
- Isolated filesystem with minimal permissions
- Built-in health checks
- No unnecessary system dependencies

## 📁 Files Included

- `Dockerfile` - Main Docker image definition
- `docker-compose.yml` - Docker Compose configuration
- `build.sh` - Build script for convenience
- `.dockerignore` - Files to exclude from Docker context

## 🚀 Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Build and run
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

### Option 2: Using Docker directly

```bash
# Build the image
chmod +x build.sh
./build.sh

# Run the container
docker run -d \
  --name octra-wallet-gen \
  -p 8888:8888 \
  --restart unless-stopped \
  octra-wallet-generator:latest
```

### Option 3: One-liner (similar to original script)

```bash
# Build and run in one command
docker run -d \
  --name octra-wallet-gen \
  -p 8888:8888 \
  --restart unless-stopped \
  $(docker build -q .)
```

## 🌐 Access

Once running, access the wallet generator at:
```
http://localhost:8888
```

## 📊 Health Monitoring

Check container health:
```bash
# Using Docker
docker ps
docker logs octra-wallet-gen

# Using Docker Compose
docker compose ps
docker compose logs
```

## 💾 Persistent Storage (Optional)

To save generated wallets persistently, uncomment the volumes section in `docker-compose.yml`:

```yaml
volumes:
  - ./wallets:/home/octra/wallets:rw
```

Then create the directory:
```bash
mkdir -p wallets
```

## 🛠 Customization

### Port Configuration
Change the port by modifying the port mapping:
```bash
docker run -p 9999:8888 octra-wallet-generator:latest
```

### Environment Variables
Set custom environment variables:
```bash
docker run -e NODE_ENV=development octra-wallet-generator:latest
```

## 🧹 Cleanup

Remove everything:
```bash
# Using Docker Compose
docker compose down --rmi all --volumes

# Using Docker directly
docker stop octra-wallet-gen
docker rm octra-wallet-gen
docker rmi octra-wallet-generator:latest
```

## ⚠️ Security Warnings

This tool generates real cryptographic keys. Always:

- Keep your private keys secure
- Never share your mnemonic phrase  
- Don't store wallet files on cloud services
- Use on a secure, offline computer for production wallets
- Consider running the container without network access for maximum security:
  ```bash
  docker run --network none -p 8888:8888 octra-wallet-generator:latest
  ```

## 🔍 Troubleshooting

### Container won't start
```bash
# Check logs
docker logs octra-wallet-gen

# Check if port is in use
lsof -i :8888
```

### Build fails
```bash
# Clean Docker cache
docker system prune -f

# Rebuild without cache
docker build --no-cache -t octra-wallet-generator:latest .
```

### Permission issues
The container runs as user `octra` (UID 1000) by default. If you need different permissions for mounted volumes:
```bash
# Check container user
docker exec octra-wallet-gen id

# Fix permissions on host
sudo chown -R 1000:1000 ./wallets
```

## 📋 Container Specifications

- **Base Image**: Ubuntu 22.04
- **Runtime**: Bun (installed automatically)
- **User**: `octra` (non-root)
- **Working Directory**: `/home/octra`
- **Exposed Port**: 8888
- **Health Check**: HTTP GET to localhost:8888

## 🏗 Development

To modify the build process, edit the `Dockerfile` and rebuild:
```bash
docker build -t octra-wallet-generator:dev .
docker run -p 8888:8888 octra-wallet-generator:dev
```