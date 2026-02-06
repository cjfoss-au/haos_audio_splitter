FROM ghcr.io/home-assistant/amd64-base-debian:latest
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        pulseaudio pulseaudio-utils ffmpeg python3 python3-pip \
    && pip3 install --break-system-packages paho-mqtt requests \
    && useradd -m audioaddon \
    && chown -R audioaddon /home/audioaddon \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY run.sh /run.sh
COPY mqtt_media_player.py /haos_audio_splitter/mqtt_media_player.py
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
