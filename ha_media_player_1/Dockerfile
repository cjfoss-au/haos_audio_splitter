FROM ghcr.io/home-assistant/amd64-base-debian:latest
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        pulseaudio pulseaudio-utils vlc passwd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY run.sh /run.sh
RUN useradd -m -s /bin/bash vlcuser \
    && chown vlcuser:vlcuser /run.sh \
    && mkdir -p /data /media /ssl \
    && chown -R vlcuser:vlcuser /data /media /ssl
RUN chmod +x /run.sh
USER vlcuser
ENTRYPOINT ["/run.sh"]
