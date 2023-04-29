#!/bin/bash -e

# Copy systemctl service file
install -v -m 755 -o 1000 -g 1000 files/sonos-streaming.service "${ROOTFS_DIR}/etc/systemd/system/"

# Enable the sonos streaming service
on_chroot << EOF
  systemctl enable sonos-streaming.service
EOF