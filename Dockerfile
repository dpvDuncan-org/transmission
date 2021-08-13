# syntax=docker/dockerfile:1
ARG BASE_IMAGE_PREFIX

FROM ${BASE_IMAGE_PREFIX}alpine

ENV PUID=0
ENV PGID=0

COPY scripts/start.sh /
COPY scripts/settings.json /var/lib/transmission/

RUN apk -U --no-cache upgrade
RUN apk add --no-cache transmission-daemon jq
RUN mkdir /config
RUN chmod -R 777 /start.sh /config

# ports and volumes
EXPOSE 9091 51414 51414/udp
VOLUME /config

CMD ["/start.sh"]