# Nym Node Docker Setup

Containerized Nym mixnode with configurable environment variables and persistent data.

## Quick Start

1. **Configure .env file**
```bash
# Node Identity
NYM_NODE_ID=my-mixnode
NYM_MODE=mixnode
NYM_ACCEPT_TERMS=true

# Network Configuration
NYM_PUBLIC_IP=your.public.ip
NYM_HOSTNAME=mixnode.yourdomain.com
NYM_LOCATION=US

# Container name
CONTAINER_NAME=nym-mixnode
```
*Local Testing*

For local testing, you must add a country code in `.env`:
```bash
NYM_PUBLIC_IP=127.0.0.1
NYM_HOSTNAME=localhost
NYM_LOCATION=US
```

The entrypoint script automatically adds the `--local` flag when using localhost/127.0.0.1.

*Production Deployment*

Replace localhost values in `.env` with real server details:
```bash
NYM_PUBLIC_IP=203.0.113.1
NYM_HOSTNAME=mixnode.example.com
NYM_LOCATION=US
```

2. **Deploy**
```bash
docker compose up -d
```

## Data Persistence

Node keys and configuration persist in the `./nym-config` bind mount directory and the `nym-data` Docker volume through updates and restarts. The node configuration and description files are stored in `./nym-config` on your host filesystem for easy access and editing.

## Node Description

Set description after initial startup:
```bash
sudo mkdir -p ./nym-config/nym-nodes/my-mixnode/data
sudo tee ./nym-config/nym-nodes/my-mixnode/data/description.toml << EOF
moniker = "my-mixnode"
website = "https://domain.com"
security_contact = "operator@domain.com"
details = "Nym mixnode operated by me"
EOF

docker compose restart nym-node
```

## Management

**View logs:**
```bash
docker compose logs -f nym-node
```

**Check status:**
```bash
curl http://localhost:8080/api/v1/build-information
curl http://localhost:8080/api/v1/description
```

**Health check:**
```bash
docker compose ps
```

**Stop and cleanup:**
```bash
docker compose down
docker compose down -v  # Remove volumes too
```

## Ports

- `1789`: Mixnet traffic
- `1790`: Verloc API  
- `8080`: HTTP API

## Troubleshooting

**Check container health:**
```bash
docker compose exec nym-node curl -f http://localhost:8080/api/v1/build-information
```

**Monitor startup:**
```bash
docker compose logs -f nym-node
```

**Reset node data:**
```bash
docker compose down -v
sudo rm -rf ./nym-config
docker compose up -d
```