# HAOS Audio Splitter Addon

This Home Assistant OS addon splits a stereo USB audio device into two mono channels and exposes them as two MQTT media players in Home Assistant.

## Features
- Records from a stereo USB sound device
- Splits the left and right channels
- Publishes each channel as a mono audio stream to MQTT
- Intended for use with MQTT Media Player integration in Home Assistant

## Usage
1. Build and install the addon in Home Assistant.
2. Configure MQTT settings in `run.sh` or via environment variables.
3. Add two MQTT media players in Home Assistant, subscribing to `haos_audio_splitter/left` and `haos_audio_splitter/right` topics.

## Note
- This is a minimal proof-of-concept. For real-time streaming, further development is needed.
- You may need to adjust the `AUDIO_DEVICE` variable in `run.sh` to match your hardware.
