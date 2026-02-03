
#!/bin/bash

# Start PulseAudio in system mode
pulseaudio --start --system --disallow-exit --disable-shm &
sleep 2

# Find the default sink (should be the USB device)
DEFAULT_SINK=$(pactl list short sinks | grep -m1 -i usb | awk '{print $2}')
if [ -z "$DEFAULT_SINK" ]; then
  DEFAULT_SINK=$(pactl list short sinks | head -n1 | awk '{print $2}')
fi
echo "Default PulseAudio sink: $DEFAULT_SINK"

# Create two mono sinks: left and right
pactl load-module module-remap-sink sink_name=mono_left master=$DEFAULT_SINK channels=2 channel_map=mono,mono master_channel_map=front-left,front-right remix=no
pactl load-module module-remap-sink sink_name=mono_right master=$DEFAULT_SINK channels=2 channel_map=mono,mono master_channel_map=front-right,front-left remix=no

# Start two VLC instances, each bound to a different sink, listening for telnet control
cvlc --intf telnet --telnet-password leftpass --telnet-port 4212 --aout=pulse --pulse-audio-device=mono_left &
cvlc --intf telnet --telnet-password rightpass --telnet-port 4213 --aout=pulse --pulse-audio-device=mono_right &

echo "Left VLC: telnet port 4212, sink mono_left. Right VLC: telnet port 4213, sink mono_right."

# Keep the container running
tail -f /dev/null
