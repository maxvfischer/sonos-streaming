#!/bin/bash -e

HOME="${ROOTFS_DIR}/home/${FIRST_USER_NAME}"

# Copy systemctl service file
install -m 755 -o 1000 -g 1000 files/sonos-streaming.service /etc/systemd/system/

# Enable the sonos streaming service
on_chroot << EOF
  systemctl enable sonos-streaming.service
EOF