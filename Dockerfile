FROM debian:bookworm-slim

ARG VERSION="2:1.25.3-1nwtf+320+12bookworm1"
ARG PACKAGE_REPO="https://mirrors.xtom.com/sb/nginx"

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates gettext-base wget; \
    wget -O /etc/apt/trusted.gpg.d/sb-nginx.asc "https://n.wtf/public.key"; \
    echo "deb $PACKAGE_REPO bookworm main" > /etc/apt/sources.list.d/sb-nginx.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends "nginx-extras=$VERSION"; \
    apt-get purge -y --auto-remove wget; \
    rm -rf /var/lib/apt/lists/*; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY docker-nginx-*.sh docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
