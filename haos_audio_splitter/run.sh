#!/bin/bash

# Clean up any old remap sinks
pactl list short modules | grep 'module-remap-sink' | awk '{print $1}' | xargs -r -n1 pactl unload-module

# Create left-only and right-only remap sinks with clear names
pactl load-module module-remap-sink sink_name=haos_left_output sink_properties=device.description="HAOS Left Output" master=alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo channels=2 channel_map=front-left,front-left
pactl load-module module-remap-sink sink_name=haos_right_output sink_properties=device.description="HAOS Right Output" master=alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo channels=2 channel_map=front-right,front-right

echo "Created PulseAudio sinks: HAOS Left Output and HAOS Right Output."

# Start the MQTT media player script as the main process
python3 /haos_audio_splitter/mqtt_media_player.py
