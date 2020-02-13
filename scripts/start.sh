#! /bin/sh
chown -R $PUID:$PGID /var/lib/transmission /config
sed -i "s/transmission:x:[0-9]\+:/transmission:x:$PUID:/" /etc/passwd

GROUPNAME=$(getent group $PGID | cut -d: -f1)
USERNAME=$(getent passwd $PUID | cut -d: -f1)

if [ ! $GROUPNAME ]
then
        addgroup -g $PGID transmission
        GROUPNAME=transmission
fi

if [ ! $USERNAME ]
then
        adduser -G $GROUPNAME -u $PUID -D transmission
        USERNAME=transmission
fi

su - $USERNAME -c 'transmission-daemon -f -g /config'
