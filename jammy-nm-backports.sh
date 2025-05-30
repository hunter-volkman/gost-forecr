#!/bin/bash
# Script to install backported NetworkManager 1.42.8 on a GOST device
# Downloads and extracts the backport archive to ~/jammy-nm-backports,
# installs .deb files, and restarts NetworkManager service

URL="https://storage.googleapis.com/packages.viam.com/ubuntu/jammy-nm-backports.tar"
DIR="$HOME/jammy-nm-backports"

echo "Downloading and extracting backport..."
mkdir -p "$DIR"
cd "$DIR"
curl -fsSL "$URL" -o jammy-nm-backports.tar
tar -xvf jammy-nm-backports.tar

echo "Installing .deb files..."
sudo dpkg -i *.deb

echo "Restarting NetworkManager..."
sudo systemctl restart NetworkManager

echo "Done. To clean up, run: rm -rf $DIR"