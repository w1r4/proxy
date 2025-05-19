#!/bin/bash

set -e

# This script cross-compiles Trojan for Alpine Linux using dockcross/x86_64-linux-musl

# Create a dockcross script if it doesn't exist
if [ ! -f ./dockcross-x86_64-linux-musl ]; then
    echo "Creating dockcross script..."
    docker run --rm dockcross/x86_64-linux-musl > ./dockcross-x86_64-linux-musl
    chmod +x ./dockcross-x86_64-linux-musl
fi

# Create build directory
mkdir -p alpine-build

# Run the build process inside the container
echo "Building Trojan for Alpine Linux..."
./dockcross-x86_64-linux-musl bash -c "\
    mkdir -p /work/build && \
    cd /work/build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_MYSQL=OFF \
        -DSYSTEMD_SERVICE=OFF && \
    make -j$(nproc) && \
    strip trojan"

# Copy the binary to the alpine-build directory
cp build/trojan alpine-build/

echo "Build completed! The Alpine-compatible binary is in the alpine-build directory."
echo "Binary information:"
file alpine-build/trojan