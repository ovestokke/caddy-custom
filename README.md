# Custom Caddy Build

A custom Docker build of [Caddy](https://caddyserver.com/) with additional plugins for enhanced functionality including DNS providers, security features, and admin UI.

## Features

This custom Caddy build includes the following plugins:

### DNS Providers
- **Cloudflare DNS** - DNS challenge support for Cloudflare-managed domains
- **WeidiDeng/caddy-cloudflare-ip** - Cloudflare IP validation

### Layer 4 Proxy
- **caddy-l4** - Layer 4 (TCP/UDP) proxy capabilities

### Security & Protection
- **CrowdSec Bouncer** - Integration with CrowdSec for application security
  - App security bouncer
  - HTTP bouncer
  - Layer 4 bouncer

### Encoding & Transformation
- **Transform Encoder** - Content transformation capabilities

### Administration
- **Admin UI** - Web-based administration interface accessible on port 2019

### Commented Out Plugins
The following plugins are available but currently commented out:
- HMAC authentication
- Additional DNS providers (DNSPod, Gandi, Route53, AliDNS, Azure, DigitalOcean, DuckDNS, Hetzner, OpenStack Designate, Vultr)
- Dynamic DNS
- Request ID tracking
- WebDAV support
- JSON parsing
- MaxMind geolocation

## Quick Start

### Using Docker Compose

1. **Set up environment variables:**
   Create a `.env` file or set the following environment variables:
   ```env
   APPDATA_ROOT=/path/to/your/data
   SERVICE_NAME=caddy
   TZ=UTC
   CLOUDFLARE_API_TOKEN=your_cloudflare_token
   ```

2. **Build and run:**
   ```bash
   docker compose -f compose-build.yaml up -d
   ```

### Using Docker Build

```bash
# Build the image
docker build -t caddy-custom .

# Run the container
docker run -d \
  --name caddy \
  -p 80:80 \
  -p 443:443 \
  -p 443:443/udp \
  -p 2019:2019 \
  -v caddy_data:/data \
  -v caddy_config:/etc/caddy \
  -e CLOUDFLARE_API_TOKEN=your_token \
  caddy-custom
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TZ` | Timezone | `UTC` |
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token for DNS challenges | Required for Cloudflare DNS |
| `APPDATA_ROOT` | Root directory for application data | Required |
| `SERVICE_NAME` | Service name for directory structure | `caddy` |

### Volumes

- `/data` - Caddy data directory (certificates, etc.)
- `/etc/caddy` - Caddy configuration files
- `/var/run/docker.sock` - Docker socket (read-only) for container discovery

### Ports

- `80` - HTTP
- `443` - HTTPS (TCP)
- `443/udp` - HTTPS (UDP/HTTP3)
- `2019` - Admin UI

## Admin Interface

The admin UI is available at `http://localhost:2019` when the container is running. This provides a web-based interface for managing Caddy configuration.

## Security with CrowdSec

This build includes CrowdSec bouncer integration for enhanced security. Make sure to configure CrowdSec properly in your environment to take advantage of these security features.

## Network Configuration

The compose file creates a `proxy` network for container communication. Ensure your other services are on the same network to enable reverse proxy functionality.

## Building from Source

If you want to modify the included plugins:

1. Edit the `Dockerfile` to add/remove plugins
2. Uncomment any plugins you want to enable
3. Rebuild the image:
   ```bash
   docker build -t caddy-custom .
   ```

## Version Information

- **Caddy Version**: 2.10.2
- **Alpine Base**: 3.22.1
- **Build Type**: Multi-stage build for optimized image size

## Support

For issues related to:
- **Caddy core**: [Caddy GitHub](https://github.com/caddyserver/caddy)
- **Individual plugins**: Check the respective plugin repositories
- **This build**: Open an issue in this repository

## License

This project follows the same license as Caddy. Individual plugins may have their own licenses.