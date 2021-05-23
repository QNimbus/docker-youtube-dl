ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION}

ARG BUILD_DATE
ARG VCS_REF
ARG YOUTUBE_DL_OVERWRITE=latest
LABEL \
    org.opencontainers.image.authors="bas@vanwetten.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.version="${YOUTUBE_DL_OVERWRITE}" \
    org.opencontainers.image.url="https://github.com/qnimbus/docker-youtube-dl" \
    org.opencontainers.image.documentation="https://github.com/qnimbus/docker-youtube-dl/blob/master/README.md" \
    org.opencontainers.image.source="https://github.com/qnimbus/docker-youtube-dl" \
    org.opencontainers.image.title="docker-youtube-dl" \
    org.opencontainers.image.description="Download with youtube-dl using command line arguments or configuration files"
HEALTHCHECK --interval=10m --timeout=10s --retries=1 CMD [ "$(wget -qO- https://duckduckgo.com 2>/dev/null)" != "" ] || exit 1

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=en_US:en \
    LOG=yes \
    YOUTUBE_DL_VERSION=$YOUTUBE_DL_OVERWRITE

RUN apk add --no-cache bash

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk add -q --progress --update --no-cache \
        ca-certificates \
        ffmpeg \
        python3 \
        su-exec

RUN apk add -q --progress --update --no-cache --virtual deps \
        wget \
        gnupg
    
RUN ln -s /usr/bin/python3 /usr/local/bin/python && \
    wget -q "https://yt-dl.org/downloads/${YOUTUBE_DL_VERSION}/youtube-dl" -O /usr/local/bin/youtube-dl && \
    wget -q "https://yt-dl.org/downloads/${YOUTUBE_DL_VERSION}/youtube-dl.sig" -O /tmp/youtube-dl.sig && \
    wget -qO- "https://yt-dl.org/downloads/${YOUTUBE_DL_VERSION}/SHA2-256SUMS" | head -n 1 | cut -d " " -f 1 && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 'ED7F5BF46B3BBED81C87368E2C393E0F18A9236D' && \
    gpg --verify /tmp/youtube-dl.sig /usr/local/bin/youtube-dl && \
    SHA256=$(wget -qO- "https://yt-dl.org/downloads/${YOUTUBE_DL_VERSION}/SHA2-256SUMS" | head -n 1 | cut -d " " -f 1) && \
    [ "$(sha256sum /usr/local/bin/youtube-dl | cut -d ' ' -f 1)" = "${SHA256}" ]

COPY init /init

RUN apk del deps && \
    rm -rf /var/cache/apk/* /tmp/youtube-dl.sig && \
    chmod +x /usr/local/bin/youtube-dl /init

WORKDIR /downloads
ENTRYPOINT ["/init"]
CMD ["--help"]
