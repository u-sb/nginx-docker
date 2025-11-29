# Docker Image for N.WTF

[n.wtf](https://n.wtf/) (formerly known as `nginx.io` or `sb-nginx`) is a Debian package provided by [m.ac](https://m.ac/) that delivers an enhanced [NGINX](https://nginx.org/) build offering the following features:

* Support for TLS 1.3 and HTTP/3 (QUIC)
* Brotli & Zstandard compression capability
* Integration with GeoIP2
* Support [nginx-acme](https://github.com/nginx/nginx-acme)

This repository hosts the source of [**Docker image for N.WTF**](https://github.com/u-sb/nginx-docker/pkgs/container/nginx).

## Basic Usage

Place your configuration files (such as `nginx.conf`) in a directory, for instance: `~/nginx-config`.

Your configuration files will **replace** [the default configuration files](https://github.com/nginx/nginx/tree/master/conf).

For comprehensive customization, it is recommended to use a complete `nginx.conf`. The repository [h5bp/server-configs-nginx](https://github.com/h5bp/server-configs-nginx) is an excellent starting point for reference configurations.

Map your configuration directory to the container using a Docker volume. You can modify the configuration path inside the container by setting an environment variable: `-e NWTF_CONFIG_DIR=/usr/src/docker-nginx/conf`.

To `run` the container, execute:

```bash
docker run --name nginx --net host --restart always -v $HOME/nginx-config:/usr/src/docker-nginx/conf:ro -d ghcr.io/u-sb/nginx
```

## Environment Variable Substitution

We have integrated the entrypoint scripts from [the official Docker image](https://github.com/nginxinc/docker-nginx). These allow NGINX configuration files ending with `.conf` to reference any environment variables. For example, to utilize local DNS resolvers obtained from `/etc/resolv.conf`, use:

```
resolver ${NGINX_LOCAL_RESOLVERS} valid=30s;
```

## Docker Compose Usage

Clone the repository and start the service using Docker Compose by running:

```bash
git clone https://github.com/u-sb/nginx-docker
cd nginx-docker
docker compose pull
docker compose up -d
```

## Configuration Reloading

If you modify your configuration after the container starts, you can apply changes without downtime.

Execute the following command after making changes:

```bash
docker exec nginx nwtf-reload
```

The `nwtf-reload` script will test your new configuration and attempt to reload the server. It will revert the changes if the test fails.

## Usage of `ensite` and `dissite`

By default, the `CMD` is processed by a script called `ensite`, which links configuration files from `sites-available/` to `sites-enabled/`.

> [!TIP]
> To run an arbitrary command instead of starting NGINX, specify the desired command (e.g., `/bin/sh`) with a `--` prefix, such as `-- /bin/sh`.

After adding a new site configuration, such as `sites-available/contoso.example.conf`, enable it by executing `ensite contoso.example.conf`. You can disable it later using `dissite contoso.example.conf` or `ensite --off contoso.example.conf`.

Remember to execute `nwtf-reload` afterward to reload NGINX.

You can define sites in the Docker Compose file like so:

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

This software is distributed under the MIT license.

NGINX is an open-source HTTP and reverse proxy server, a mail proxy server, and a general-purpose TCP/UDP proxy server, available under a 2-clause BSD-like license.

NGINX is a trademark of F5 NETWORKS, INC.

Please note that we are not affiliated with NGINX Inc. or F5 NETWORKS, INC.
