#!/bin/bash

# Set log file
LOG_FILE="/var/log/boot-setup.log"
mkdir -p /var/log
echo "$(date): Running hostname boot setup" >> "$LOG_FILE"

# Get unique identifier from serial number
if [ -f "/proc/device-tree/serial-number" ]; then
    SERIAL=$(cat /proc/device-tree/serial-number)
    # Trim to a reasonable length (last 8 characters)
    UNIQUE_ID=$(echo "$SERIAL" | tail -c 9)
    echo "$(date): Got serial number: $SERIAL, using ID: $UNIQUE_ID" >> "$LOG_FILE"
else
    echo "$(date): ERROR: No serial number found in /proc/device-tree/serial-number" >> "$LOG_FILE"
    exit 1
fi

# Set new hostname with the new format
NEW_HOSTNAME="specter-ai-${UNIQUE_ID}"
echo "$(date): Setting new hostname to $NEW_HOSTNAME" >> "$LOG_FILE"

# Update hostname
# sudo hostnamectl hostname "$NEW_HOSTNAME"
echo "$NEW_HOSTNAME" > /etc/hostname
hostname "$NEW_HOSTNAME"

# Update hosts file safely
cp /etc/hosts /etc/hosts.bak
if grep -q "127.0.1.1" /etc/hosts; then
    sed -i "s/127.0.1.1.*/127.0.1.1\t${NEW_HOSTNAME}/" /etc/hosts
else
    echo -e "127.0.1.1\t${NEW_HOSTNAME}" >> /etc/hosts
fi

# Clear viam-agent config cache if it exists to ensure fresh configuration
if [ -f "/opt/viam/cache/config_cache.json" ]; then
    echo "$(date): Removing viam-agent config cache" >> "$LOG_FILE"
    rm -f /opt/viam/cache/config_cache.json
fi

# Create marker file to indicate successful completion


MARKER_FILE="/opt/forecr/.boot-setup-marker"
mkdir -p /opt/forecr
touch "$MARKER_FILE"
echo "$(date): Created marker file at /opt/forecr/.boot-setup-marker" >> "$LOG_FILE"

# Restart viam-agent to ensure it picks up the new hostname
if systemctl is-active --quiet viam-agent; then
    echo "$(date): Restarting viam-agent to update hotspot name" >> "$LOG_FILE"
    systemctl restart viam-agent
fi

echo "$(date): Setup complete" >> "$LOG_FILE"
