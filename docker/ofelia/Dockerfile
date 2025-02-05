FROM mcuadros/ofelia:0.3.15

SHELL ["/bin/ash", "-e", "-u", "-o", "pipefail", "-c"]

COPY ./docker/alpine/rootfs/ /
COPY ./docker/ofelia/rootfs/ /

CMD ["daemon", "--config", "/etc/ofelia.conf"]
