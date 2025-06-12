#!/bin/bash

# Check for root permissions
if [[ $EUID -ne 0 ]]; then
   echo "❌ Please run this script as root."
   exit 1
fi

# Prompt for input values
read -p "Enter ClientAliveInterval (in seconds): " interval
read -p "Enter ClientAliveCountMax: " count

# Backup original sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "✅ Backup created at /etc/ssh/sshd_config.bak"

# Remove existing lines if they exist
sed -i '/^ClientAliveInterval/d' /etc/ssh/sshd_config
sed -i '/^ClientAliveCountMax/d' /etc/ssh/sshd_config

# Append new settings
echo "ClientAliveInterval $interval" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax $count" >> /etc/ssh/sshd_config

echo "✅ SSH timeout values updated in /etc/ssh/sshd_config"

# Restart SSH service (auto-detect name)
if systemctl list-units --type=service | grep -q "ssh.service"; then
    systemctl restart ssh.service && echo "🔁 SSH service restarted"
elif systemctl list-units --type=service | grep -q "sshd.service"; then
    systemctl restart sshd.service && echo "🔁 SSHD service restarted"
else
    echo "⚠️ SSH service not found. Please restart it manually."
fi



## provide arguments as ./ssh-session-timeout-change.sh 900 2       # for 30 minutes i.e. 900 sec =15 min and 15*2 = 30 min
