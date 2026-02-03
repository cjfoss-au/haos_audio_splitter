#!/bin/bash

echo "Starting ffmpeg to split stereo input into two mono streams..."

# Ensure /media directory exists and is writable
mkdir -p /media
chown audioaddon:audioaddon /media
chmod 775 /media

# Check for channel_test_mode in options.json
CHANNEL_TEST_MODE=$(jq -r '.channel_test_mode' /data/options.json)
if [ "$CHANNEL_TEST_MODE" = "true" ]; then
  echo "Channel test mode enabled: recording and generating test files in /media."
  su - audioaddon -c "ffmpeg -f pulse -i default -t 10 -acodec pcm_s16le /media/test_stereo.wav"
  su - audioaddon -c "ffmpeg -i /media/test_stereo.wav -af 'pan=stereo|c0=c0|c1=0' /media/test_left.wav"
  su - audioaddon -c "ffmpeg -i /media/test_stereo.wav -af 'pan=stereo|c0=0|c1=c1' /media/test_right.wav"
  echo "Test files created: /media/test_stereo.wav, /media/test_left.wav, /media/test_right.wav"
else
  # Use ffmpeg to mute one channel per stream and send to VLC
  su - audioaddon -c "ffmpeg -f pulse -i default -af 'pan=stereo|c0=c0|c1=0' -f wav - | cvlc --intf telnet --telnet-password leftpass --telnet-port 4212 - &"
  su - audioaddon -c "ffmpeg -f pulse -i default -af 'pan=stereo|c0=0|c1=c1' -f wav - | cvlc --intf telnet --telnet-password rightpass --telnet-port 4213 - &"
  echo "Left VLC: telnet port 4212, right VLC: telnet port 4213. Each receives a stereo stream with only its assigned channel."
fi

echo "Left VLC: telnet port 4212, right VLC: telnet port 4213. Each receives a mono stream from ffmpeg."

tail -f /dev/null
