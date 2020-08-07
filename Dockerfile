FROM alpine:edge
MAINTAINER C4

# Install tor
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl shadow tini tor nginx iptables && \
    mkdir -p /etc/tor/run && \
    chown -Rh tor. /var/lib/tor /etc/tor/run && \
    chmod 0750 /etc/tor/run && \
    rm -rf /tmp/*

COPY torrc /etc/tor
COPY nginx.conf /etc/nginx
COPY run.sh /usr/bin

RUN chmod +x /usr/bin/run.sh

EXPOSE 9050 9051 9040 9848

HEALTHCHECK --interval=60s --timeout=15s --start-period=20s \
            CMD curl -sx socks5h://localhost:9050 'https://check.torproject.org/' | \
            grep -qm1 Congratulations

VOLUME ["/etc/tor", "/var/lib/tor"]


ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/run.sh"]