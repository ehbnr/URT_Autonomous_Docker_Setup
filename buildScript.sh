#!/bin/bash

echo "Updating repos"
apt update

# Configuration for tzdata prompt asking for region
env DEBIAN_FRONTEND=noninteractive 
env TZ=Etc/UTC 
apt-get -y install tzdata

# Install required packages
echo "Installing packages..."
apt install -y \
build-essential \
software-properties-common \
cmake \
g++ \
wget \
unzip \
lsb-release \
sudo \
curl \
git \
neovim \
libopencv-dev \
libudev1 