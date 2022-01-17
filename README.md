# Docker image for [nginx.io](https://nginx.io/)

[nginx.io](https://nginx.io/) (formerly known as sb-nginx) is a Debian package by [xTom](https://xtom.com/) offering a nginx build supports:

 * Brotli compression
 * OpenSSL 3.0.1 with TLS 1.3 support
 * GeoIP2
 * [**Hosted on GitHub Packages!**](https://github.com/nginx-io/docker-sb-nginx/pkgs/container/nginx)

## **Awesome** Usage

Put your config files (`nginx.conf` etc.) inside a folder, for example: `~/nginx-config`.

Then `run` the container:

```bash
docker run --name nginx --net host --restart always -v $HOME/nginx-config:/usr/src/docker-nginx/conf:ro -d ghcr.io/nginx-io/nginx
```

You **must** mount the config dir to this specific `/usr/src/docker-nginx/conf` path!

Your existing config files will **replace** default config files.

## Using Docker Compose

```bash
git clone https://github.com/nginx-io/nginx-io-docker
cd nginx-io-docker
docker-compose pull
docker-compose up -d
```

### Reload Changed Configuration

You can even change your configuration after the container start and apply them without any downtime.

After change, run the command:

```bash
docker exec nginx docker-nginx-reload.sh
```

This `docker-nginx-reload.sh` script will test your new configuration and reload the server. It will rollback if the test fails.
