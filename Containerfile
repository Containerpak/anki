FROM ubuntu:26.04 AS source

RUN apt-get update && \
    apt-get install -y --no-install-recommends zstd

ADD --checksum=sha256:88785a68b0e361ec173ff38410fe0ee4388b2723da0ef1cf0746c5e862e4a7df https://github.com/ankitects/anki/releases/download/26.08.1/anki-26.08.1-linux-x86_64.tar.zst /tmp/app.tar.zst

RUN mkdir -p /stage && \
    tar --zstd -xf /tmp/app.tar.zst -C /stage --strip-components=1

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/anki"

COPY --from=source /stage/ /opt/anki/
COPY anki /usr/bin/anki
COPY anki.desktop /usr/share/applications/anki.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/anki.png

RUN chmod 0755 /usr/bin/anki && cpak-clean-junk
