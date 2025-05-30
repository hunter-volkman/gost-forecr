#!/bin/bash
# Exit on error
set -e

echo "Adding NVIDIA CUDA repository..."
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/arm64/ /" | sudo tee /etc/apt/sources.list.d/cuda-ubuntu2204-arm64.list

echo "Adding NVIDIA package signing key..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/arm64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb

echo "Updating package lists..."
sudo apt update

echo "Installing core packages..."
sudo apt install -y nvidia-l4t-core nvidia-l4t-cuda

echo "Installing CUDA toolkit..."
sudo apt install -y cuda-toolkit-12-6 || sudo apt install -y cuda-toolkit-12-0

echo "Installing deep learning libraries..."
sudo apt install -y tensorrt libcudnn9-cuda-12 libcudnn9-dev-cuda-12

echo "Installing container toolkit..."
sudo apt install -y nvidia-container-toolkit

echo "Installing multimedia components..."
sudo apt install -y nvidia-l4t-jetson-multimedia-api nvidia-l4t-graphics-demos nvidia-l4t-gstreamer

echo "Installation complete!"
