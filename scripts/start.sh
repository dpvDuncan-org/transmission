#! /bin/sh

[ ! -f /config/settings.json ] && cp /var/lib/transmission/settings.json /config/

download_dir=$(jq -r .[\"download-dir\"] /config/settings.json)
incomplete_dir_enabled=$(jq -r .[\"incomplete-dir-enabled\"] /config/settings.json)
watch_dir_enabled=$(jq -r .[\"watch-dir-enabled\"] /config/settings.json)

if [ "${incomplete_dir_enabled}" = "true" ]
then
        incomplete_dir=$(jq -r .[\"incomplete-dir\"] /config/settings.json)
        [ ! -d ${incomplete_dir} ] && mkdir -p ${incomplete_dir}
        chown -R $PUID:$PGID  ${incomplete_dir}
fi
if [ "${watch_dir_enabled}" = "true" ]
then
        watch_dir=$(jq -r .[\"watch-dir\"] /config/settings.json)
        [ ! -d ${watch_dir} ] && mkdir -p ${watch_dir}
        chown -R $PUID:$PGID  ${watch_dir}
fi

[ ! -d ${download_dir} ] && mkdir -p ${download_dir}

chown -R $PUID:$PGID /var/lib/transmission /config ${download_dir}

GROUPNAME=$(getent group $PGID | cut -d: -f1)
USERNAME=$(getent passwd $PUID | cut -d: -f1)

if [ ! $GROUPNAME ]
then
        addgroup -g $PGID transmission-user
        GROUPNAME=transmission-user
fi

if [ ! $USERNAME ]
then
        adduser -G $GROUPNAME -u $PUID -D transmission-user
        USERNAME=transmission-user
fi

su $USERNAME -c 'transmission-daemon -f -g /config'