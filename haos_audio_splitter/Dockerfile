FROM ghcr.io/home-assistant/amd64-base-debian:latest
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        pulseaudio pulseaudio-utils ffmpeg \
    && useradd -m audioaddon \
    && chown -R audioaddon /home/audioaddon \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
