#!/bin/bash

# Extract the device ID given to the U-PHONE UFO202 by
# the OS.
DEVICE_ID="$(arecord -l | awk '/^card/ {gsub(/:/,"",$2); print $2}')"

# Overwrite and use the device ID in the darkice config
sed -i "s/<DEVICE_ID>/$DEVICE_ID/g" darkice.cfg

# Start Darkice service with the config
darkice -c darkice.cfg
