# Cross-Compilation Guide for Trojan on Alpine Linux

## Overview

This guide provides detailed instructions for cross-compiling the Trojan proxy application for Alpine Linux from an Ubuntu Codespace environment. Alpine Linux uses musl libc instead of glibc, which requires special consideration during compilation.

## Prerequisites

- Docker installed and running
- Git repository of Trojan cloned
- Internet connection to pull the Docker image

## Available Scripts

Two scripts have been provided to help with cross-compilation:

1. `build-alpine.sh` - Basic cross-compilation script
2. `cross-compile-alpine.sh` - Enhanced script with better error handling and verification

## Step-by-Step Instructions

### 1. Prepare Your Environment

Ensure you're in the Trojan repository directory:

```bash
cd /home/codespace/trojan
```

### 2. Choose a Script and Run It

For most users, the enhanced script is recommended:

```bash
./cross-compile-alpine.sh
```

This script will:
- Verify Docker is installed and running
- Create a dockcross script for the x86_64-linux-musl toolchain
- Set up a build environment inside the container
- Configure CMake with appropriate options for Alpine Linux
- Compile Trojan with static linking against musl libc
- Strip the binary to reduce size
- Copy the resulting binary to the `alpine-build` directory

### 3. Verify the Build

After the script completes, it will display information about the compiled binary. You should see that it's linked with musl libc, making it compatible with Alpine Linux.

### 4. Deploying to Alpine Linux

Copy the binary from the `alpine-build` directory to your Alpine Linux system:

```bash
scp alpine-build/trojan user@alpine-host:/path/to/destination/
```

### 5. Configuration

Create a configuration file on your Alpine system. You can use the examples provided in the `examples/` directory as templates:

```bash
mkdir -p /etc/trojan
cp examples/client.json-example /etc/trojan/config.json
# Edit the configuration file as needed
```

## Build Options

By default, the cross-compilation scripts disable:
- MySQL support (not commonly used in Alpine environments)
- Systemd service installation (Alpine uses OpenRC, not systemd)

If you need to modify these options or add other CMake parameters, edit the script and adjust the CMake command line.

## Troubleshooting

### Docker Issues

If you encounter Docker-related errors:
- Ensure Docker is installed: `docker --version`
- Verify Docker service is running: `docker info`
- Check if you have permission to use Docker: `docker ps`

### Compilation Errors

If the build fails:
- Check the error messages for missing dependencies
- Verify that the Docker container has access to the source code
- Ensure you're running the script from the root of the Trojan repository

## Advanced Usage

### Custom Build Options

To customize the build with different options, edit the script and modify the CMake parameters. For example, to enable MySQL support:

```bash
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_MYSQL=ON \
    -DSYSTEMD_SERVICE=OFF
```

Refer to the `docs/build.md` file for all available CMake options.

## Notes

- The compiled binary is statically linked against musl libc but dynamically linked against other libraries like OpenSSL and Boost
- For a fully static build, additional CMake parameters would be needed
- Alpine Linux may require installing runtime dependencies like `libssl` and `boost`