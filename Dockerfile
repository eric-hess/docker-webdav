FROM alpine:3.17

RUN apk upgrade --no-cache && apk add --no-cache \
    nginx \
    nginx-mod-http-dav-ext \
    openssl

COPY webdav.conf /etc/nginx/http.d/default.conf

COPY entrypoint.sh /opt/webdav/entrypoint.sh

ENV WEBDAV_USER=webdav
ENV WEBDAV_PASSWORD=webdav

ENTRYPOINT ["/opt/webdav/entrypoint.sh"]

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]