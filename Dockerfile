FROM alpine:3.19

RUN apk add --no-cache stunnel openssl

# Create stunnel user and directories
RUN addgroup -g 1000 stunnel && \
    adduser -u 1000 -G stunnel -s /bin/sh -D stunnel && \
    mkdir -p /etc/stunnel /var/run/stunnel && \
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

USER stunnel

ENTRYPOINT ["/entrypoint.sh"]
CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
