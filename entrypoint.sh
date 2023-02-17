#!/bin/sh

HTPASSWD_FILE=/opt/webdav/.htpasswd

if [ ! -f "$HTPASSWD_FILE" ]; then
    echo "$WEBDAV_USER:$(openssl passwd -apr1 $WEBDAV_PASSWORD)" > $HTPASSWD_FILE
fi

exec "$@"