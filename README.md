# Nym Node Docker Setup

Containerized Nym mixnode with configurable environment variables and persistent data.

## Quick Start

1. **Create project directory**
```bash
mkdir nym-docker && cd nym-docker
```

2. **Create required files**
   - `Dockerfile` 
   - `entrypoint.sh`
   - `docker-compose.yml`
   - `.env` (customize values below)

3. **Configure .env file**
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

4. **Deploy**
```bash
docker compose up -d
```

## Local Testing

For local testing, use these values in `.env`:
```bash
NYM_PUBLIC_IP=127.0.0.1
NYM_HOSTNAME=localhost
NYM_LOCATION=local
```

The entrypoint script automatically adds the `--local` flag when using localhost/127.0.0.1.

## Production Deployment

Replace localhost values in `.env` with real server details:
```bash
NYM_PUBLIC_IP=203.0.113.1
NYM_HOSTNAME=mixnode.example.com
NYM_LOCATION=US
```

## Node Description

Set description after initial startup:
```bash
docker exec -it nym-mixnode sh -c 'cat > /nym-data/description.toml << EOF
moniker = "my-mixnode"
website = "https://domain.com"
security_contact = "operator@domain.com"
details = "Nym mixnode operated by me"
EOF'

docker compose restart nym-node
```

## Updates

**Update to new version:**
1. Edit `NYM_VERSION` in Dockerfile:
```dockerfile
ENV NYM_VERSION=v1.14.0
```

2. Rebuild and deploy:
```bash
docker compose build --no-cache
docker compose up -d
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

## Data Persistence

Node keys and configuration persist in the `nym-data` Docker volume through updates and restarts.

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
docker compose up -d
```