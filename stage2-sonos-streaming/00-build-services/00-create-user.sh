#!/bin/bash -e

on_chroot << EOF
  echo -n "${FIRST_USER_NAME:='pi'}:" > /boot/userconf.txt
  openssl passwd -5 "${FIRST_USER_PASS:='raspberry'}" >> /boot/userconf.txt

  touch /boot/ssh

  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  export DEBIAN_FRONTEND=noninteractive
EOF


