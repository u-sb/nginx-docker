FROM debian:bookworm-slim

ARG VERSION="2:1.27.1-2nwtf+332+12bookworm1"
ARG PACKAGE_REPO="https://mirrors.xtom.com/sb/nginx"

ENV NWTF_BASE="/var/lib/n.wtf"
ENV NWTF_CONFIG_DIR="/usr/src/docker-nginx/conf"

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates gettext-base wget; \
    wget -O /usr/share/keyrings/n-wtf.asc "https://n.wtf/public.key"; \
    echo "deb [signed-by=/usr/share/keyrings/n-wtf.asc] $PACKAGE_REPO bookworm main" > /etc/apt/sources.list.d/n-wtf.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends "nginx-extras=$VERSION"; \
    apt-get purge -y --auto-remove wget; \
    rm -rf /var/lib/apt/lists/*; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY root /

ENTRYPOINT ["nwtf-start"]
