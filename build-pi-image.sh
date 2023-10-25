#!/bin/bash

# 1. Install build requirements of pi-gen
apt-get update -y
apt-get install coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx gpg pigz xxd -y

# 2. Clone the pi-gen repository
git clone https://github.com/RPi-Distro/pi-gen.git
if [ $? -ne 0 ]; then
  echo "Failed to clone pi-gen repository"
  exit 1
fi

# 3. Tell pi-gen to only build a lite system
touch ./pi-gen/stage3/SKIP ./pi-gen/stage4/SKIP ./pi-gen/stage5/SKIP
touch ./pi-gen/stage4/SKIP_IMAGES ./pi-gen/stage5/SKIP_IMAGES
touch ./pi-gen/stage2/SKIP_IMAGES # Skip image of stage 2, as we add our own custom stage3 after

# 4. Create custom pi-gen stage
rm -rf ./pi-gen/stage3
mkdir -p ./pi-gen/stage3

## Add pi-gen config
cat << EOF > ./pi-gen/config
IMG_NAME='sonos-streaming'
DEPLOY_COMPRESSION='xz'
COMPRESSION_LEVEL='9'
EOF

## Add prerun script to start from previous pi-gen state
cat << 'EOF' > ./pi-gen/stage3/prerun.sh
#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi
EOF
chmod +x ./pi-gen/stage3/prerun.sh

## Add docker installation script
mkdir -p ./pi-gen/stage3/00-install-docker
cp ./install-docker.sh ./pi-gen/stage3/00-install-docker/00-run-chroot.sh
chmod +x ./pi-gen/stage3/00-install-docker/00-run-chroot.sh

## Copy required files
mkdir -p ./pi-gen/stage3/01-copy-files
cat << 'EOF' > ./pi-gen/stage3/01-copy-files/00-run.sh
#!/bin/bash -e

STREAMING_FOLDER="${ROOTFS_DIR}/etc/sonos-streaming"
DARKICE="${STREAMING_FOLDER}/darkice"
ICECAST="${STREAMING_FOLDER}/icecast"

# Create streaming folder
install -v -d      "${STREAMING_FOLDER}"

# Copy Darkice files
install -v -d     "${DARKICE}"
install -v -m 755 ../../../darkice/Dockerfile.darkice "${DARKICE}/"
install -v -m 755 ../../../darkice/darkice.cfg "${DARKICE}/"
install -v -m 755 ../../../darkice/start-darkice.sh "${DARKICE}/"

# Copy Icecast files
install -v -d     "${ICECAST}"
install -v -m 755 ../../../icecast/Dockerfile.icecast "${ICECAST}/"
install -v -m 755 ../../../icecast/icecast.xml "${ICECAST}/"

# Copy docker-compose file
install -v -m 755 ../../../docker-compose.yml "${STREAMING_FOLDER}/"
EOF
chmod +x ./pi-gen/stage3/01-copy-files/00-run.sh

## Add service setup script
mkdir -p ./pi-gen/stage3/02-setup-sonos-streaming
cp ./setup-service.sh ./pi-gen/stage3/02-setup-sonos-streaming/00-run-chroot.sh
sed -i 's|$(pwd)|/etc/sonos-streaming|g' ./pi-gen/stage3/02-setup-sonos-streaming/00-run-chroot.sh
chmod +x ./pi-gen/stage3/02-setup-sonos-streaming/00-run-chroot.sh

## Tell pi-gen to export an image of our custom stage
touch ./pi-gen/stage3/EXPORT_IMAGE

# 6. Start image build
cd ./pi-gen
./build.sh
