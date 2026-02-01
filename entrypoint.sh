#!/bin/sh

HTPASSWD_FILE=/opt/webdav/.htpasswd

PUID=${PUID:-0}
PGID=${PGID:-0}

# Configure based on PUID/PGID
if [ "$PUID" = "0" ]; then
    NGINX_USER="root"
else
    NGINX_USER="webdav"

    # Modify webdav user/group to match PUID/PGID
    groupmod -o -g "$PGID" webdav
    usermod -o -u "$PUID" webdav

    # Ensure directories have correct ownership
    chown -R webdav:webdav /opt/webdav /var/lib/nginx /var/log/nginx /run/nginx

    # Ensure webdav data directory has correct permissions
    if [ -d /mnt/webdav ]; then
        chown -R webdav:webdav /mnt/webdav 2>/dev/null || true
    fi
fi

# Update nginx.conf with the correct user
sed -i "s/user nginx;/user $NGINX_USER;/g" /etc/nginx/nginx.conf
sed -i "s/user root;/user $NGINX_USER;/g" /etc/nginx/nginx.conf
sed -i "s/user webdav;/user $NGINX_USER;/g" /etc/nginx/nginx.conf

# Update listen port in webdav config
sed -i "s/LISTEN_PORT/$LISTEN_PORT/g" /etc/nginx/http.d/default.conf

# Create htpasswd file if it doesn't exist
if [ ! -f "$HTPASSWD_FILE" ]; then
    echo "$WEBDAV_USER:$(openssl passwd -apr1 $WEBDAV_PASSWORD)" > $HTPASSWD_FILE
    chown $NGINX_USER:$NGINX_USER $HTPASSWD_FILE 2>/dev/null || true
fi

# Update max upload size
sed -i "s/client_max_body_size 0;/client_max_body_size $WEBDAV_MAX_UPLOAD_SIZE;/g" /etc/nginx/http.d/default.conf

exec "$@"
