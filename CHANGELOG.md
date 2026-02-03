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
