FROM nginx:1.26-alpine3.20

SHELL ["/bin/ash", "-e", "-u", "-o", "pipefail", "-c"]

ARG NGINX_UID
ARG NGINX_GID

ENV NGINX_UID=${NGINX_UID}
ENV NGINX_GID=${NGINX_GID}

RUN apk add \
      --no-cache \
      shadow \
    && groupmod \
      --gid ${NGINX_GID} \
      nginx \
    && usermod \
      --gid ${NGINX_GID} \
      --uid ${NGINX_UID} \
      nginx

COPY ./docker/alpine/rootfs/ /
COPY ./docker/nginx/rootfs/ /

RUN mkdir -p /var/www/html
COPY ./app /var/www/html

#USER nginx

EXPOSE 80
