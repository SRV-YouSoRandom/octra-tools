# Use Ubuntu as base image
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash octra && \
    mkdir -p /home/octra/.octra && \
    chown -R octra:octra /home/octra

# Switch to non-root user
USER octra
WORKDIR /home/octra

# Set environment variables
ENV HOME=/home/octra
ENV PATH="$HOME/.bun/bin:$PATH"

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash

# Set up working directory
WORKDIR /home/octra/wallet-gen

# Repository information
ENV REPO_OWNER="octra-labs"
ENV REPO_NAME="wallet-gen"
ENV INSTALL_DIR="/home/octra/.octra"

# Download and build the wallet generator
RUN LATEST_TAG=$(curl -s "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/tags" | \
    grep '"name":' | \
    head -1 | \
    sed 's/.*"name": "\(.*\)".*/\1/') && \
    echo "Downloading version: $LATEST_TAG" && \
    curl -L -o release.tar.gz "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/tarball/refs/tags/${LATEST_TAG}" && \
    tar -xzf release.tar.gz --strip-components=1 && \
    rm release.tar.gz && \
    bun install && \
    bun run build && \
    cp ./wallet-generator ${INSTALL_DIR}/ && \
    chmod +x ${INSTALL_DIR}/wallet-generator

# Clean up build files but keep the executable
WORKDIR /home/octra
RUN rm -rf /home/octra/wallet-gen

# Expose the port
EXPOSE 8888

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8888 || exit 1

# Run the wallet generator
CMD ["/home/octra/.octra/wallet-generator"]