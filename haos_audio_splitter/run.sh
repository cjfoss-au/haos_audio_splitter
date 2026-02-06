#!/bin/bash

export PULSE_SERVER=unix:/run/audio/pulse.sock

DEFAULT_SINK=$(pactl list short sinks | grep -m1 -i usb | awk '{print $2}')
if [ -z "$DEFAULT_SINK" ]; then
  DEFAULT_SINK=$(pactl list short sinks | head -n1 | awk '{print $2}')
fi

pactl unload-module $(pactl list short modules | grep 'sink_name=mono_left' | awk '{print $1}')
pactl unload-module $(pactl list short modules | grep 'sink_name=mono_right' | awk '{print $1}')

pactl load-module module-remap-sink sink_name=mono_left master=$DEFAULT_SINK channels=1 channel_map=mono master_channel_map=front-left remix=no
pactl load-module module-remap-sink sink_name=mono_right master=$DEFAULT_SINK channels=1 channel_map=mono master_channel_map=front-right remix=no

echo "Created mono_left and mono_right sinks."

tail -f /dev/null
