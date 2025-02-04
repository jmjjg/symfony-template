FROM postgres:17.2-alpine3.21

SHELL ["/bin/ash", "-e", "-u", "-o", "pipefail", "-c"]

COPY ./docker/alpine/rootfs/ /
COPY ./docker/postgresql/rootfs/ /

RUN mkdir -p /var/www/html
COPY ./app /var/www/html
