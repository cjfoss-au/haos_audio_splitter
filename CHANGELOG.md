# Changelog

## 0.2.35
- Escape | in pan filter for ffmpeg in temp script
- Bump version for Home Assistant update detection

## 0.2.36
- Add paplay output and channel selection to MQTT media player script
- Allow playback of left or right channel via MQTT payload

## 0.2.37
- Add MQTT config options (broker, port, user, pass, discovery prefix) to config.json for UI configuration
- Update mqtt_media_player.py to read config from /data/options.json

## 0.2.38
- Remove old VLC/ffmpeg pipeline from run.sh
- Only run MQTT media player script as main process

## 0.2.39
- Remove all old remap sinks on startup
- Create only two new remap sinks: 'HAOS Left Output' and 'HAOS Right Output' with clear names
- Remove all old pipeline code from run.sh

## 0.2.40
- Add python3, pip, and required Python packages (paho-mqtt, requests) to Dockerfile for MQTT media player support

## 0.2.41
- Remove ladspa-sdk and swh-plugins from Dockerfile to fix build errors
- Only install required packages for MQTT and playback

## 0.2.42
- Add --break-system-packages to pip3 install in Dockerfile to fix externally-managed-environment error
- Bump version to 0.2.42

## 0.2.43
- Remove VLC from Dockerfile (no longer needed)
- Bump version to 0.2.43

## 0.2.44
- Add check and delay in run.sh to wait for USB audio device before creating remap sinks
- Bump version to 0.2.44
