FROM ghcr.io/home-assistant/amd64-base-debian:latest

RUN apt-get update && \
    apt-get install -y alsa-utils ffmpeg mosquitto-clients python3-pip && \
    pip3 install paho-mqtt && \
    apt-get clean

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
