# Debug: print all detected soundcards
echo "Detected soundcards (arecord -l):"
arecord -l || true

#!/bin/bash

# Set device and MQTT info (customize as needed)
AUDIO_DEVICE="hw:1,0"
MQTT_HOST="homeassistant.local"
MQTT_PORT=1883
MQTT_USER=""
MQTT_PASS=""


# Check if audio device exists
if ! arecord -l | grep -q "$AUDIO_DEVICE"; then
  echo "Audio device $AUDIO_DEVICE not found. Exiting."
  exit 1
fi

# Record and split stereo to two mono files (left/right)
arecord -D $AUDIO_DEVICE -f S16_LE -c2 -r 44100 | \
  ffmpeg -y -f s16le -ar 44100 -ac 2 -i - \
    -map_channel 0.0.0 -ac 1 left.wav \
    -map_channel 0.0.1 -ac 1 right.wav

# Publish to MQTT (example, replace with streaming logic)
if [ -f left.wav ]; then
  mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "haos_audio_splitter/left" -f left.wav
else
  echo "left.wav not found, skipping MQTT publish."
fi
if [ -f right.wav ]; then
  mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "haos_audio_splitter/right" -f right.wav
else
  echo "right.wav not found, skipping MQTT publish."
fi

# TODO: Loop or daemonize as needed
