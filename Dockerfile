FROM alpine:3.19

RUN apk add --no-cache stunnel openssl

# Create directories and fix permissions
# (stunnel package already creates stunnel user)
RUN mkdir -p /etc/stunnel /var/run/stunnel && \
    chown -R stunnel:stunnel /etc/stunnel /var/run/stunnel

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Environment variables with defaults
ENV STUNNEL_CLIENT=yes
ENV STUNNEL_ACCEPT=127.0.0.1:11194
ENV STUNNEL_CONNECT=example.com:443
ENV STUNNEL_CERT=/etc/stunnel/stunnel.pem

EXPOSE 11194

# Note: Running as root to allow reading mounted certs with various permissions
# Stunnel drops privileges internally after loading the cert

ENTRYPOINT ["/entrypoint.sh"]
CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
