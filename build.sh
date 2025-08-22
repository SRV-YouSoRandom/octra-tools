#!/bin/bash

set -e

echo "=== Building Octra Wallet Generator Docker Image ==="
echo ""

# Build the Docker image
echo "Building Docker image..."
docker build -t octra-wallet-generator:latest .

echo ""
echo "=== Build Complete ==="
echo ""
echo "To run the container:"
echo "  docker run -p 8888:8888 octra-wallet-generator:latest"
echo ""
echo "Or use docker-compose:"
echo "  docker-compose up -d"
echo ""
echo "The wallet generator will be available at http://localhost:8888"
echo ""
echo "=== Security Reminders ==="
echo "- Keep your private keys secure"
echo "- Never share your mnemonic phrase"
echo "- Don't store wallet files on cloud services"
echo "- Use on a secure, offline computer for production wallets"