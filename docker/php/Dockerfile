FROM alpine:3.20 AS php

SHELL ["/bin/ash", "-e", "-u", "-o", "pipefail", "-c"]

ARG PHP_UID=82
ARG PHP_GID=82

ENV PHP_UID=${PHP_UID}
ENV PHP_GID=${PHP_GID}

RUN apk add \
      --no-cache \
      bash \
      curl \
      icu-libs \
      icu-data-full \
      gnu-libiconv \
      php82 \
      php82-bcmath \
      php82-common \
      php82-ctype \
      php82-curl \
      php82-dom \
      php82-iconv \
      php82-intl \
      php82-mbstring \
      php82-opcache \
      php82-openssl \
      php82-pdo \
      php82-pdo_pgsql \
      php82-phar \
      php82-posix \
      php82-session \
      php82-simplexml \
      php82-tokenizer \
      php82-xml \
      php82-zip \
      # Iconv Fix
      php82-pecl-apcu \
      tzdata \
    && ln -sf /usr/bin/php82 /usr/bin/php \
    && curl -1sLf \
      'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash \
    && apk add \
      --no-cache \
      symfony-cli \
    # workaround for iconv issue
    # @see https://github.com/PHOENIX-MEDIA/docker-nginx-php/commit/1d0ce191950609721b3fd1594f042b43a96fa73e
    # php -r 'echo iconv("UTF-8", "ISO-8859-1//TRANSLIT", "foobar");'
    && apk add \
      --no-cache \
      --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ \
      gnu-libiconv==1.15-r3 \
    && apk del --no-cache bash \
    && rm -rf /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

# @todo: check packages and extensions in official image
# @todo: backport configration

COPY ./docker/alpine/rootfs/ /
COPY ./docker/php/rootfs /

ARG src_dir=./app
ARG dst_dir=/var/www/html

RUN mkdir -p ${dst_dir}
WORKDIR ${dst_dir}

COPY ${src_dir} ${dst_dir}

RUN sed -i "s/^www-data:\([^:]\+\):82:/www-data:\1:${PHP_UID}:/g" /etc/group \
    && adduser -u ${PHP_UID} -D -S -G www-data www-data

USER www-data

RUN mkdir -p /home/www-data/.composer \
    && curl -1sLf https://composer.github.io/snapshots.pub -o /home/www-data/.composer/keys.dev.pub \
    && curl -1sLf https://composer.github.io/releases.pub -o /home/www-data/.composer/keys.tags.pub

# ------------------------------------------------------------------------------

FROM php AS php-cli

# ------------------------------------------------------------------------------

#FROM php-cli AS php-cron
#
#USER root
#
#RUN apk add \
#      --no-cache \
#      dcron \
#    && rm -rf /var/cache/apk/*
#
#COPY ./docker/php-cron/rootfs /
##RUN chmod 644 /etc/crontabs/root
#
##USER www-data
#
#CMD ["/usr/sbin/crond", "-f", "-L", "/proc/1/fd/1"]
#
# ------------------------------------------------------------------------------

FROM php AS php-fpm

USER root

RUN apk add \
      --no-cache \
      #libavif \
      #php82-dev \
      #php82-exif \
      php82-fpm \
      #php82-gd \
      #php82-pcntl \
      #php82-sodium \
      #php82-xmlreader \
      #php82-xmlwriter \
      #php82-xsl \
      #php82-zlib \
    && ln -sf /usr/sbin/php-fpm82 /usr/sbin/php-fpm \
    && rm -rf /var/cache/apk/*

COPY ./docker/php-fpm/rootfs /

USER www-data

CMD ["/usr/sbin/php-fpm", "-R", "--nodaemonize"]

EXPOSE 9000

# ------------------------------------------------------------------------------

FROM php-cli AS php-supervisor

USER root

RUN apk add \
      --no-cache \
      supervisor \
    && rm -rf /var/cache/apk/*

#COPY --chown=www-data:www-data ./docker/php-supervisor/rootfs /
#RUN chown www-data: /etc/supervisord.conf

COPY ./docker/php-supervisor/rootfs /

#USER www-data

CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisord.conf", "--nodaemon"]
