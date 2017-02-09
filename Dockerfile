FROM alpine:edge

RUN apk --update --no-cache add ca-certificates
    
ENV GOSU_VERSION 1.10
RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps dpkg openssl
    
RUN apk add --no-cache --update tini su-exec
    
ENTRYPOINT ["/sbin/tini", "--"]
