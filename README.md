# Octra Wallet Generator - Docker

Run the Octra Wallet Generator in a secure Docker container with non-root user isolation.

## 🚀 Quick Start

### Option 1: One-liner (Easiest)

```bash
# Run the wallet generator
docker run -d -p 8888:8888 --name octra-wallet-gen srvsorandom/octra-wallet-generator:latest
```

**Access:** http://localhost:8888

**Manage the container:**
```bash
# Check logs
docker logs octra-wallet-gen

# Stop and remove
docker stop octra-wallet-gen && docker rm octra-wallet-gen
```

### Option 2: Docker Compose

**For users (pre-built image):**
```bash
# Start
docker compose up -d

# Check logs
docker compose logs -f

# Stop and cleanup
docker compose down
```

**For developers (build from source):**
```bash
# Build and start
docker compose -f docker-compose.dev.yml up -d --build

# Check logs
docker compose logs -f

# Stop and cleanup
docker compose down --rmi all
```

## 🔒 Security Features

- Non-root user execution
- Isolated filesystem
- Minimal attack surface
- Built-in health checks

## ⚠️ Security Warnings

**This generates real crypto keys:**
- Keep private keys secure
- Never share mnemonic phrases
- Don't store wallets on cloud services
- Use offline for production wallets

**Maximum security (no network):**
```bash
docker run --network none -p 8888:8888 srvsorandom/octra-wallet-generator:latest
```

## 🛠 Advanced Usage

**Custom port:**
```bash
docker run -d -p 9999:8888 --name octra-wallet-gen srvsorandom/octra-wallet-generator:latest
```

**Persistent wallet storage:**
```bash
mkdir wallets
docker run -d -p 8888:8888 -v ./wallets:/home/octra/wallets --name octra-wallet-gen srvsorandom/octra-wallet-generator:latest
```

## 🔍 Troubleshooting

**Container won't start:**
```bash
# Check what's wrong
docker logs octra-wallet-gen

# Check if port is busy
lsof -i :8888
```

**Complete cleanup:**
```bash
# Remove container and image
docker stop octra-wallet-gen && docker rm octra-wallet-gen
docker rmi srvsorandom/octra-wallet-generator:latest

# Clean everything
docker system prune -f
```

## 📋 Files in this repo

- `Dockerfile` - Image build instructions
- `docker-compose.yml` - Uses pre-built image
- `docker-compose.dev.yml` - Builds from source
- `build-and-push.sh` - Developer script to build and publish