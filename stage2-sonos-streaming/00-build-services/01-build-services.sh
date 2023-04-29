#!/bin/bash -e

HOME="${ROOTFS_DIR}/home/${FIRST_USER_NAME}"
DARKICE = "${HOME}/darkice"
ICECAST = "${HOME}/icecast"

# Copy Darkice files
install -v -d                     "${DARKICE}"
install -v -m 755 -o 1000 -g 1000 files/darkice/Dockerfile.darkice "${DARKICE}/"
install -v -m 755 -o 1000 -g 1000 files/darkice/darkice.cfg "${DARKICE}/"
install -v -m 755 -o 1000 -g 1000 files/darkice/start-darkice.sh "${DARKICE}/"

# Copy Icecast files
install -v -d                     "${ICECAST}"
install -v -m 755 -o 1000 -g 1000 files/icecast/Dockerfile.icecast "${ICECAST}/"
install -v -m 755 -o 1000 -g 1000 files/icecast/icecast.xml "${ICECAST}/"

# Copy docker-compose file
install -v -m 755 -o 1000 -g 1000 files/docker-compose.yml "${HOME}/"

# Create env file with the path of where the docker compose file is stored.
# This is used by the systemctl service to be able to locate the docker compose file
on_chroot << EOF
  echo "DOCKER_COMPOSE_FILE=/home/${FIRST_USER_NAME}/docker-compose.yml" >> "/etc/streaming-service.env"
EOF

# Build Darkice and Icecast docker images
on_chroot << EOF
  docker compose -f "/home/${FIRST_USER_NAME}/docker-compose.yml" build
EOF