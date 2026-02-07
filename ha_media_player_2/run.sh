#!/bin/bash

export PULSE_SERVER=unix:/run/audio/pulse.sock


# Diagnostic: print permissions and contents of /data/options.json
echo "[DIAG] Listing /data and permissions:"
ls -l /data
echo "[DIAG] Showing /data/options.json contents:"
cat /data/options.json || echo "[DIAG] Could not read /data/options.json"

# Read options from Home Assistant UI
TELNET_PASSWORD=$(jq -r '.telnet_password // empty' /data/options.json)
TELNET_PORT=$(jq -r '.telnet_port // empty' /data/options.json)
AUDIO_OUTPUT=$(jq -r '.audio_output // empty' /data/options.json)

# AUDIO_OUTPUT fallback remains for backward compatibility
if [ -z "$AUDIO_OUTPUT" ] || [ "$AUDIO_OUTPUT" = "null" ]; then
  AUDIO_OUTPUT="default"
fi

echo "Starting VLC as audioaddon user on sink: $AUDIO_OUTPUT, port: $TELNET_PORT"
su - audioaddon -c "cvlc --intf telnet --telnet-password '$TELNET_PASSWORD' --telnet-port '$TELNET_PORT' --aout=alsa --alsa-audio-device='$AUDIO_OUTPUT' --no-daemon --no-plugins-cache --no-dbus &"
echo "VLC Telnet interface running on port $TELNET_PORT. Use Home Assistant VLC integration to control playback."

tail -f /dev/null
