FROM ubuntu:26.04 AS source

RUN apt-get update && \
    apt-get install -y --no-install-recommends zstd

ADD --checksum=sha256:e9a80bcfc3dc3e44e270ec3d51b434db5fab6150257cc921e0d3552c213b36a4 https://github.com/ankitects/anki/releases/download/26.09/anki-26.09-linux-x86_64.tar.zst /tmp/app.tar.zst

RUN mkdir -p /stage && \
    tar --zstd -xf /tmp/app.tar.zst -C /stage --strip-components=1

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/anki"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libnspr4 \
        libnss3 \
        libxtst6 \
        libxcb-cursor0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-render-util0 \
        libxcb-shape0 \
        libxcb-util1 \
        libxcb-xkb1 \
        libxkbcommon-x11-0 \
        libxkbfile1 && \
    cpak-clean-junk

COPY --from=source /stage/ /opt/anki/
COPY anki /usr/bin/anki
COPY anki.desktop /usr/share/applications/anki.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/anki.png

RUN chmod 0755 /usr/bin/anki && cpak-clean-junk
