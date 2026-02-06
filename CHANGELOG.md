# Changelog

## 0.3.2
- Add error checking and detailed logging for remap sink creation in run.sh

## 0.3.1
- Remove leftover python3 call from run.sh
- Finalize minimal PulseAudio sink splitter addon

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

## 0.2.45
- Add COPY command for mqtt_media_player.py in Dockerfile so script is available in container
- Bump version to 0.2.45

## 0.2.46
- Fix config variable scoping and paho-mqtt callback API version in mqtt_media_player.py
- Bump version to 0.2.46

## 0.2.47
- Fix paho-mqtt Client constructor to use keyword arguments for client_id and callback_api_version
- Bump version to 0.2.47

## 0.2.48
- Remove callback_api_version argument from paho-mqtt Client constructor for maximum compatibility
- Bump version to 0.2.48

## 0.3.0
- Remove all MQTT, Python, and media player code
- Only create PulseAudio remap sinks for left/right channel isolation
- Minimal addon for sink management
