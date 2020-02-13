ARG BASE_IMAGE_PREFIX

FROM multiarch/qemu-user-static as qemu

FROM ${BASE_IMAGE_PREFIX}alpine

COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/

ENV PUID=0
ENV PGID=0

COPY scripts/start.sh /
COPY scripts/settings.json /var/lib/transmission/

RUN apk -U --no-cache upgrade
RUN apk add --no-cache transmission-daemon
RUN mkdir /config
RUN chmod -R 777 /start.sh /config

RUN rm -rf /usr/bin/qemu-*-static

# ports and volumes
EXPOSE 9091 51414 51414/udp
VOLUME /config

CMD ["/start.sh"]