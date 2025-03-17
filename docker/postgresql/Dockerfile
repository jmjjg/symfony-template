FROM postgres:17.2-alpine3.21

SHELL ["/bin/ash", "-e", "-u", "-o", "pipefail", "-c"]

ENV LANG=fr_FR.utf8
ENV POSTGRES_INITDB_ARGS="--locale-provider=icu --icu-locale=fr_FR"

COPY ./docker/alpine/rootfs/ /
COPY ./docker/postgresql/rootfs/ /

#RUN mkdir -p /var/www/html
#COPY ./app /var/www/html
