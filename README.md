# A simple webdav docker container

## Quick Start

```bash
docker run -it --rm \
    --publish 8080:80 \
    --volume $PWD:/mnt/webdav \
    --env WEBDAV_USER=webdav \
    --env WEBDAV_PASSWORD=webdav \
    ghcr.io/eric-hess/docker-webdav:latest
```

Now you can access the webdav server via the following link: `http://webdav:webdav@localhost:8080`
The `webdav:webdav` part is the lazy variant if you do not always want to be asked for the user credentials

If you want to have more than just one user make sure you mount a own version of the `.htpasswd` in the container.

```bash
docker run -it --rm \
    --publish 8080:80 \
    --volume $PWD:/mnt/webdav \
    --volume $PWD/.htpasswd:/opt/webdav/.htpasswd \
    ghcr.io/eric-hess/docker-webdav:latest
```

## Available env variables
| Variable name            | Default value              | Description                                                                                                                               |
|--------------------------|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `WEBDAV_USER`            | webdav                     | The username of the user who should be created                                                                                            |
| `WEBDAV_PASSWORD`        | webdav                     | The users password which should be user                                                                                                   |
| `WEBDAV_MAX_UPLOAD_SIZE` | 0                          | Sets the maximum allowed size of the client request body. (http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size)  |
| `PUID`                   | 0                          | User ID for nginx process. Set to non-zero to run as non-root user                                                                        |
| `PGID`                   | 0                          | Group ID for nginx process. Set together with PUID                                                                                        |
| `LISTEN_PORT`            | 80                         | Port nginx listens on inside the container                                                                                                |
