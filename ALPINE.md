# Cross-compiling Trojan for Alpine Linux

This guide explains how to cross-compile the Trojan proxy for Alpine Linux from an Ubuntu environment.

## Prerequisites

- Docker installed and running
- Git repository of Trojan cloned

## Build Process

1. Make the build script executable:

```bash
chmod +x build-alpine.sh
```

2. Run the build script:

```bash
./build-alpine.sh
```

The script will:
- Create a dockcross script for the x86_64-linux-musl toolchain
- Set up a build environment inside the container
- Configure CMake with appropriate options for Alpine Linux
- Compile Trojan with static linking against musl libc
- Strip the binary to reduce size
- Copy the resulting binary to the `alpine-build` directory

## Build Options

The default build disables MySQL support and systemd service installation, which are typically not needed in Alpine environments. If you need to modify these options, edit the `build-alpine.sh` script and adjust the CMake parameters.

## Deployment

The resulting binary in the `alpine-build` directory can be copied to an Alpine Linux system and executed. It is statically linked against musl libc, making it compatible with Alpine's environment.

## Configuration

After deploying the binary, you'll need to create a configuration file. See the examples in the `examples/` directory for reference.