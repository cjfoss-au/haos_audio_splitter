#!/bin/bash

# Set device and MQTT info (customize as needed)
AUDIO_DEVICE="hw:1,0"
MQTT_HOST="homeassistant.local"
MQTT_PORT=1883
MQTT_USER=""
MQTT_PASS=""

# Split stereo to two mono files (left/right)
arecord -D $AUDIO_DEVICE -f cd -c2 -r 44100 | \
  ffmpeg -f s16le -ar 44100 -ac 2 -i - \
    -map_channel 0.0.0 left.wav \
    -map_channel 0.0.1 right.wav

# Publish to MQTT (example, replace with streaming logic)
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "haos_audio_splitter/left" -f left.wav
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "haos_audio_splitter/right" -f right.wav

# Loop or daemonize as needed
