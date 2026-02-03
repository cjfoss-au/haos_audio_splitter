
#!/bin/bash


echo "Starting PulseAudio and VLC as audioaddon user..."
su - audioaddon -c "pulseaudio --daemonize --disallow-exit --disable-shm"
sleep 2

DEFAULT_SINK=$(su - audioaddon -c "pactl list short sinks | grep -m1 -i usb | awk '{print \$2}'")
if [ -z "$DEFAULT_SINK" ]; then
  DEFAULT_SINK=$(su - audioaddon -c "pactl list short sinks | head -n1 | awk '{print \$2}'")
fi
echo "Default PulseAudio sink: $DEFAULT_SINK"

su - audioaddon -c "pactl load-module module-remap-sink sink_name=mono_left master=$DEFAULT_SINK channels=1 channel_map=front-left remix=no"
su - audioaddon -c "pactl load-module module-remap-sink sink_name=mono_right master=$DEFAULT_SINK channels=1 channel_map=front-right remix=no"

su - audioaddon -c "PULSE_SINK=mono_left cvlc --intf telnet --telnet-password leftpass --telnet-port 4212 --aout=pulse &"
su - audioaddon -c "PULSE_SINK=mono_right cvlc --intf telnet --telnet-password rightpass --telnet-port 4213 --aout=pulse &"

echo "Left VLC: telnet port 4212, sink mono_left. Right VLC: telnet port 4213, sink mono_right."

tail -f /dev/null
