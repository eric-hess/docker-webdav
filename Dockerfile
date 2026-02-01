FROM alpine:3.23

RUN apk upgrade --no-cache && apk add --no-cache \
    nginx \
    nginx-mod-http-dav-ext \
    nginx-mod-http-headers-more \
    openssl \
    shadow

# Create webdav user/group for non-root operation
RUN addgroup -g 1000 webdav && \
    adduser -D -u 1000 -G webdav -h /opt/webdav webdav

# Prepare directories with appropriate permissions
RUN mkdir -p /opt/webdav /var/lib/nginx /var/log/nginx /run/nginx && \
    chown -R webdav:webdav /opt/webdav /var/lib/nginx /var/log/nginx /run/nginx && \
    chmod -R 755 /opt/webdav /var/lib/nginx /var/log/nginx /run/nginx

COPY webdav.conf /etc/nginx/http.d/default.conf

COPY entrypoint.sh /opt/webdav/entrypoint.sh
RUN chmod +x /opt/webdav/entrypoint.sh

ENV WEBDAV_USER=webdav
ENV WEBDAV_PASSWORD=webdav
ENV WEBDAV_MAX_UPLOAD_SIZE=0
ENV PUID=0
ENV PGID=0
ENV LISTEN_PORT=80

ENTRYPOINT ["/opt/webdav/entrypoint.sh"]

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]