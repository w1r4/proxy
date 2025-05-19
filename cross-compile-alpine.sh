#!/bin/bash

set -e

# Enhanced script for cross-compiling Trojan for Alpine Linux
# This script handles dependencies and provides better error handling

echo "=== Trojan Cross-Compilation for Alpine Linux ==="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is required but not installed. Please install Docker first."
    exit 1
fi

# Check if the Docker service is running
docker info &> /dev/null || { echo "Error: Docker service is not running. Please start Docker."; exit 1; }

# Ensure we're in the trojan directory
if [ ! -f "CMakeLists.txt" ] || [ ! -d "src" ]; then
    echo "Error: Please run this script from the root of the Trojan repository."
    exit 1
fi

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
echo "This may take a few minutes depending on your system."

./dockcross-x86_64-linux-musl bash -c "\
    set -e && \
    echo 'Preparing build environment...' && \
    mkdir -p /work/build && \
    cd /work/build && \
    echo 'Configuring with CMake...' && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_MYSQL=OFF \
        -DSYSTEMD_SERVICE=OFF && \
    echo 'Compiling Trojan...' && \
    make -j$(nproc) && \
    echo 'Stripping binary...' && \
    strip trojan"

if [ $? -ne 0 ]; then
    echo "Error: Build failed. Please check the output for errors."
    exit 1
fi

# Copy the binary to the alpine-build directory
if [ -f build/trojan ]; then
    echo "Copying binary to alpine-build directory..."
    cp build/trojan alpine-build/
    
    # Verify the binary
    echo "\nBuild completed successfully!"
    echo "Alpine-compatible binary information:"
    file alpine-build/trojan
    
    echo "\nThe Alpine-compatible binary is in the alpine-build directory."
    echo "You can now copy this binary to your Alpine Linux system."
    echo "Remember to create a configuration file based on the examples in the examples/ directory."
else
    echo "Error: Could not find the compiled binary."
    exit 1
fi