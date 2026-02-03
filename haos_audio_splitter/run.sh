#!/bin/bash

echo "Starting ffmpeg to split stereo input into two mono streams..."

# Ensure /media directory exists and is writable
mkdir -p /media
chown audioaddon:audioaddon /media
chmod 775 /media

# Find the monitor source for the USB sink
USB_SINK="alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo"
MONITOR_SOURCE="${USB_SINK}.monitor"

# Check for channel_test_mode in options.json
CHANNEL_TEST_MODE=$(jq -r '.channel_test_mode' /data/options.json)
#if [ "$CHANNEL_TEST_MODE" = "true" ]; then
#  echo "Channel test mode enabled: generating pink noise, playing to USB device, and recording from monitor source."
#  # Generate 10s of pink noise and play to USB device
#  if [ ! -f /media/test_stereo.wav ]; then
#    su - audioaddon -c "ffmpeg -f lavfi -i anoisesrc=color=pink:duration=10 -f wav - | paplay --device=$USB_SINK &"
#  fi
#  # Record from monitor source
#  su - audioaddon -c "ffmpeg -f pulse -i $MONITOR_SOURCE -t 10 -acodec pcm_s16le /media/test_stereo.wav"
#  # Wait to ensure test_stereo.wav is fully written
#  sleep 2
#  # Always generate left and right channel files from test_stereo.wav (overwrite if needed)
#  su - audioaddon -c "ffmpeg -y -loglevel debug -i /media/test_stereo.wav -af 'pan=mono|c0=FL' /media/test_left.wav 2>/media/ffmpeg_left.log"
#  su - audioaddon -c "ffmpeg -y -loglevel debug -i /media/test_stereo.wav -af 'pan=mono|c0=FR' /media/test_right.wav 2>/media/ffmpeg_right.log"
#  echo "Test files created: /media/test_stereo.wav, /media/test_left.wav, /media/test_right.wav"
#else
# Use ffmpeg to mute one channel per stream and send to VLC
# Write ffmpeg+VLC commands to temp scripts to avoid quoting issues
cat <<'EOF' > /tmp/left_ffmpeg_vlc.sh
#!/bin/bash
ffmpeg -f pulse -i default -af pan=stereo\|c0=FL\|c1=0 -f wav - | cvlc --intf telnet --telnet-password leftpass --telnet-port 4212 -
EOF
chmod +x /tmp/left_ffmpeg_vlc.sh
su - audioaddon -c "bash /tmp/left_ffmpeg_vlc.sh" &

cat <<'EOF' > /tmp/right_ffmpeg_vlc.sh
#!/bin/bash
ffmpeg -f pulse -i default -af pan=stereo\|c0=0\|c1=FR -f wav - | cvlc --intf telnet --telnet-password rightpass --telnet-port 4213 -
EOF
chmod +x /tmp/right_ffmpeg_vlc.sh
su - audioaddon -c "bash /tmp/right_ffmpeg_vlc.sh" &

echo "Left VLC: telnet port 4212, right VLC: telnet port 4213. Each receives a stereo stream with only its assigned channel."
#fi

echo "Left VLC: telnet port 4212, right VLC: telnet port 4213. Each receives a mono stream from ffmpeg."

tail -f /dev/null
