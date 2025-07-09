FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Environment variables with defaults (fallbacks if no .env used)
ENV NYM_NODE_ID=my-mixnode
ENV NYM_MODE=mixnode
ENV NYM_ACCEPT_TERMS=true

# Download and install nym-node
RUN wget https://github.com/nymtech/nym/releases/download/nym-binaries-v2025.11-cheddar/nym-node -O /usr/local/bin/nym-node \
    && chmod +x /usr/local/bin/nym-node

# Create entrypoint script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Build command with environment variables\n\
CMD="/usr/local/bin/nym-node run --id $NYM_NODE_ID --mode $NYM_MODE"\n\
\n\
if [ "$NYM_ACCEPT_TERMS" = "true" ]; then\n\
    CMD="$CMD --accept-operator-terms-and-conditions"\n\
fi\n\
\n\
# Add local flag for testing with localhost/127.0.0.1\n\
if [ "$NYM_PUBLIC_IP" = "127.0.0.1" ] || [ "$NYM_HOSTNAME" = "localhost" ]; then\n\
    CMD="$CMD --local"\n\
fi\n\
\n\
# Add public IP if specified\n\
if [ ! -z "$NYM_PUBLIC_IP" ]; then\n\
    CMD="$CMD --public-ips $NYM_PUBLIC_IP"\n\
fi\n\
\n\
# Add hostname if specified\n\
if [ ! -z "$NYM_HOSTNAME" ]; then\n\
    CMD="$CMD --hostname $NYM_HOSTNAME"\n\
fi\n\
\n\
# Add location if specified\n\
if [ ! -z "$NYM_LOCATION" ]; then\n\
    CMD="$CMD --location $NYM_LOCATION"\n\
fi\n\
\n\
# Add any additional arguments passed to container\n\
if [ $# -gt 0 ]; then\n\
    CMD="$CMD $@"\n\
fi\n\
\n\
echo "Running: $CMD"\n\
exec $CMD' > /entrypoint.sh && chmod +x /entrypoint.sh

# Expose required ports for mixnode
EXPOSE 1789 1790 8080

WORKDIR /nym-data

ENTRYPOINT ["/entrypoint.sh"]