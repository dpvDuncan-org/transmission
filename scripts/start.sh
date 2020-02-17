#! /bin/sh

[ ! -f /config/settings.json ] && cp /var/lib/transmission/settings.json /config/

chown -R $PUID:$PGID /var/lib/transmission /config

# sed -i "s/transmission:x:[0-9]\+:/transmission:x:$PUID:/" /etc/passwd
# sed -i "s/users:x:[0-9]\+:/users:x:$PGID:/" /etc/group

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

sudo -u $USERNAME -g $GROUPNAME transmission-daemon -f -g /config