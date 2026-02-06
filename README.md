# Stunnel Docker

Lightweight stunnel proxy in Docker with environment-based configuration.

## Quick Start

```bash
docker run -d \
  -e STUNNEL_CONNECT=vpn.example.com:443 \
  -p 11194:11194 \
  stunnel-docker
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `STUNNEL_CLIENT` | `yes` | Client mode (`yes`) or server mode (`no`) |
| `STUNNEL_ACCEPT` | `127.0.0.1:11194` | Local address:port to listen on |
| `STUNNEL_CONNECT` | `example.com:443` | Remote host:port to tunnel to |
| `STUNNEL_CERT` | `/etc/stunnel/stunnel.pem` | Path to certificate file |
| `STUNNEL_VERIFY` | (unset) | Verify peer certificate (0-4) |
| `STUNNEL_CAFILE` | (unset) | Path to CA file for verification |
| `STUNNEL_CHECK_HOST` | (unset) | Expected hostname in certificate |

## Use Cases

### OpenVPN over SSL (bypass DPI)

```bash
docker run -d \
  --name stunnel-vpn \
  -e STUNNEL_CONNECT=your-vpn-server.com:443 \
  -e STUNNEL_ACCEPT=0.0.0.0:11194 \
  -p 11194:11194 \
  stunnel-docker

# Then connect OpenVPN to localhost:11194
openvpn --config client.ovpn --remote 127.0.0.1 11194 tcp-client
```

### Docker Compose

Edit `docker-compose.yml` to set your target host, then:

```bash
docker-compose up -d
```

## Building

```bash
docker build -t stunnel-docker .
```

## Security Notes

- In client mode with `STUNNEL_VERIFY=0`, certificates are not validated (vulnerable to MITM)
- For production use, set `STUNNEL_VERIFY=2` or higher and provide proper CA chain
- Runs as non-root user (stunnel:stunnel)
