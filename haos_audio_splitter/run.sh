#!/bin/bash

# Wait for USB audio device to appear in PulseAudio
USB_SINK="alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo"
MAX_WAIT=30
WAITED=0
while ! pactl list short sinks | grep -q "$USB_SINK"; do
    echo "Waiting for USB audio device ($USB_SINK) to appear..."
    sleep 1
    WAITED=$((WAITED+1))
    if [ $WAITED -ge $MAX_WAIT ]; then
        echo "USB audio device not found after $MAX_WAIT seconds. Exiting."
        exit 1
    fi
done

echo "USB audio device found: $USB_SINK"

# Clean up any old remap sinks by name if they exist
for SINK in haos_left_output haos_right_output; do
    MODULE_ID=$(pactl list short modules | grep "sink_name=$SINK" | awk '{print $1}')
    if [ -n "$MODULE_ID" ]; then
        echo "Unloading existing module for $SINK (module-id $MODULE_ID)"
        pactl unload-module "$MODULE_ID"
    fi
done

# Create left-only and right-only remap sinks with error checking
LEFT_RESULT=$(pactl load-module module-remap-sink sink_name=haos_left_output sink_properties=device.description="HAOS Left Output" master=$USB_SINK channels=2 channel_map=front-left,front-left 2>&1)
if [[ $LEFT_RESULT =~ ^[0-9]+$ ]]; then
    echo "Left sink created successfully (module-id $LEFT_RESULT)"
else
    echo "Failed to create left sink: $LEFT_RESULT"
fi

RIGHT_RESULT=$(pactl load-module module-remap-sink sink_name=haos_right_output sink_properties=device.description="HAOS Right Output" master=$USB_SINK channels=2 channel_map=front-right,front-right 2>&1)
if [[ $RIGHT_RESULT =~ ^[0-9]+$ ]]; then
    echo "Right sink created successfully (module-id $RIGHT_RESULT)"
else
    echo "Failed to create right sink: $RIGHT_RESULT"
fi

echo "Script complete."

# Keep the container running
sleep infinity
