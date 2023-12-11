# Docker image for Nginx

[n.wtf](https://n.wtf/) (formerly known as `nginx.io` or `sb-nginx`) is a Debian package by [SB Blog](https://u.sb/) offering a [nginx](https://nginx.org/) build supports:

 * QUIC support
 * Brotli compression
 * [QUIC TLS] 3.1.x with TLS 1.3 support
 * GeoIP2
 * [**Hosted on GitHub Packages!**](https://github.com/u-sb/nginx-docker/pkgs/container/nginx)

## **Awesome** Usage

Put your config files (`nginx.conf` etc.) inside a folder, for example: `~/nginx-config`.

Your existing config files will **replace** [the default config files](https://github.com/nginx/nginx/tree/master/conf).

It is recommended to provide a full `nginx.conf` so that all options can be tuned as needed. [h5bp/server-configs-nginx](https://github.com/h5bp/server-configs-nginx) can be a good reference.

Use Docker volume to map the config directory into the container. You can change the configuration path inside the container with environment: `-e NWTF_CONFIG_DIR=/usr/src/docker-nginx/conf`.

Then `run` the container:

```bash
docker run --name nginx --net host --restart always -v $HOME/nginx-config:/usr/src/docker-nginx/conf:ro -d ghcr.io/u-sb/nginx
```

### Envsubst

We merged entrypoint scripts from [the official Docker image source](https://github.com/nginxinc/docker-nginx). You can refer to any environment variables in NGINX config files ending with `.conf`. For example, you can use the local DNS resolvers extracted from `/etc/resolv.conf` by:

```
resolver ${NGINX_LOCAL_RESOLVERS} valid=30s;
```

### Using Docker Compose

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
docker exec nginx nwtf-reload
```

This `nwtf-reload` script will test your new configuration and reload the server. It will rollback if the test fails.

## `ensite` and `dissite`

By default, the command (`CMD`) is passed to a script called `ensite`. It links config files inside `sites-available/` to `sites-enable/`.

> [!TIP]
> To run arbitary command (rather than start NGINX), specify command (e.g. `/bin/sh`) with `--` prefixed like `-- /bin/sh`.

Whenever you added a new site e.g. `sites-available/contoso.example.conf`, you can enable it by execute `ensite contoso.example.conf`, or disable it later by `dissite contoso.example.conf` or `ensite --off contoso.example.conf`.

Don't forget to execute `nwtf-reload` to reload the NGINX.

This enables you to define sites like this in the Docker compose file:

```yaml
services:
  nginx:
    volumes:
    - "/home/debian/nginx-config:/usr/src/docker-nginx/conf:ro"
    command:
    - default.conf
    - options/websocket.conf
    - contoso.example.conf
```

## License and Trademark

We distribute this software under the MIT license.

[nginx](https://nginx.org/en/) is a opensource HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server distributed under the 2-clause BSD-like license. 

NGINX is a trademark of F5 NETWORKS, INC. 

We are not affiliated with NGINX Inc. and/or F5 NETWORKS, INC.
