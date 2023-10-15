#!/usr/bin/env bash
SERVICENAME="sonos-streaming"

echo "Creating a systemd service file: /etc/systemd/system/${SERVICENAME}.service"

# Create systemd file
sudo cat > /etc/systemd/system/$SERVICENAME.service << EOF
[Unit]
Description=Sonos streaming service
Requires=docker.service
After=docker.service

[Service]
User=root
Group=docker
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$(pwd)

ExecStartPre=/usr/bin/docker compose down

# Compose up
ExecStart=/usr/bin/docker compose up -d

# Compose down
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling the service ${SERVICENAME}.service"
# Autostart systemd service
sudo systemctl enable $SERVICENAME.service
