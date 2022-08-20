# Docker image for Nginx

[n.wtf](https://n.wtf/) (formerly known as `nginx.io` or `sb-nginx`) is a Debian package by [SB Blog](https://u.sb/) offering a [nginx](https://nginx.org/) build supports:

 * Brotli compression
 * OpenSSL 3.0.x with TLS 1.3 support
 * GeoIP2
 * [**Hosted on GitHub Packages!**](https://github.com/u-sb/nginx-docker/pkgs/container/nginx)

## **Awesome** Usage

Put your config files (`nginx.conf` etc.) inside a folder, for example: `~/nginx-config`.

Then `run` the container:

```bash
docker run --name nginx --net host --restart always -v $HOME/nginx-config:/usr/src/docker-nginx/conf:ro -d ghcr.io/u-sb/nginx
```

You **must** mount the config dir to this specific `/usr/src/docker-nginx/conf` path!

Your existing config files will **replace** default config files.

## Using Docker Compose

```bash
git clone https://github.com/u-sb/nginx-docker
cd nginx-docker
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

## License and Trademark

We distribute this software under the MIT license.

[nginx](https://nginx.org/en/) is a opensource HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server distributed under the 2-clause BSD-like license. 

NGINX is a trademark of F5 NETWORKS, INC. 

We are not affiliated with NGINX Inc. and/or F5 NETWORKS, INC.
