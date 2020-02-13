#! /bin/sh

[ ! -f /config/settings.json ] && cp /var/lib/transmission/settings.json /config/

chown -R $PUID:$PGID /var/lib/transmission /config

sed -i "s/transmission:x:[0-9]\+:/transmission:x:$PUID:/" /etc/passwd
sed -i "s/users:x:[0-9]\+:/users:x:$PGID:/" /etc/group

transmission-daemon -f -g /config