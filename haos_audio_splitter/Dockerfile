FROM ghcr.io/home-assistant/amd64-base-debian:latest

# Troubleshooting: show sources and versions
RUN cat /etc/apt/sources.list && cat /etc/os-release

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        alsa-utils ffmpeg mosquitto-clients python3-pip \
    && pip3 install --no-cache-dir paho-mqtt \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
