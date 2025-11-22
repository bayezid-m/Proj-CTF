#!/bin/bash

# Install dependencies
sudo apt-get install -y \
    build-essential \
    libpcap-dev \
    libpcre3-dev \
    libdumbnet-dev \
    bison flex \
    zlib1g-dev \
    liblzma-dev \
    openssl libssl-dev \
    libnghttp2-dev \
    libluajit-5.1-dev \
    libtirpc-dev \
    libtool autoconf \
    pkg-config automake

# Install daq
cd ~/Downloads
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz
tar -xvzf daq-2.0.7.tar.gz
cd daq-2.0.7
./configure
make
sudo make install

# Install Snort
cd ~/Downloads
wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz
tar -xvzf snort-2.9.20.tar.gz
cd snort-2.9.20
sudo ln -s /usr/include/tirpc/rpc /usr/include/rpc
./configure CFLAGS="-I/usr/include/tirpc" LDFLAGS="-L/usr/lib/x86_64-linux-gnu -ltirpc" --enable-sourcefire --with-daq=/usr/local
make
sudo make install
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/local.conf
sudo ldconfig