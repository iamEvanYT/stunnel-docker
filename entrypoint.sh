#!/bin/sh
set -e

# Generate stunnel.conf from environment variables
cat > /etc/stunnel/stunnel.conf <<EOF
foreground = yes
pid = /var/run/stunnel/stunnel.pid

[proxy]
client = ${STUNNEL_CLIENT}
accept = ${STUNNEL_ACCEPT}
connect = ${STUNNEL_CONNECT}
EOF

# Add cert only if file exists (client mode doesn't need it)
if [ -f "${STUNNEL_CERT}" ]; then
    echo "cert = ${STUNNEL_CERT}" >> /etc/stunnel/stunnel.conf
fi

# Optional: add verify settings if provided
if [ -n "$STUNNEL_VERIFY" ]; then
    echo "verify = ${STUNNEL_VERIFY}" >> /etc/stunnel/stunnel.conf
fi

# Optional: CA file for verifying server certs
if [ -n "$STUNNEL_CAFILE" ]; then
    echo "CAfile = ${STUNNEL_CAFILE}" >> /etc/stunnel/stunnel.conf
fi

# Optional: check host
if [ -n "$STUNNEL_CHECK_HOST" ]; then
    echo "checkHost = ${STUNNEL_CHECK_HOST}" >> /etc/stunnel/stunnel.conf
fi

echo "Generated stunnel.conf:"
cat /etc/stunnel/stunnel.conf

# Execute the main command
exec "$@"
