#!/bin/bash

export PULSE_SERVER=unix:/run/audio/pulse.sock

AUDIO_OUTPUT=$(jq -r '.audio_output' /data/options.json)
if [ -z "$AUDIO_OUTPUT" ] || [ "$AUDIO_OUTPUT" = "null" ]; then
  AUDIO_OUTPUT="default"
fi

echo "Starting VLC with Telnet interface on sink: $AUDIO_OUTPUT"

 cvlc --intf telnet --telnet-password "$VLC_TELNET_PASSWORD" --telnet-port "$VLC_TELNET_PORT" --aout=alsa --alsa-audio-device="$AUDIO_OUTPUT" --no-daemon --no-plugins-cache &

echo "VLC Telnet interface running on port 4212. Use Home Assistant VLC integration to control playback."

tail -f /dev/null
