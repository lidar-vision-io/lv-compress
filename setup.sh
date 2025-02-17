#!/bin/bash

# Ensure vcpkg is installed system-wide
if [ ! -d "/opt/vcpkg" ]; then
    echo "Installing vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git /opt/vcpkg
    /opt/vcpkg/bootstrap-vcpkg.sh
fi

# Set environment variable
export VCPKG_ROOT="/opt/vcpkg"

# Install dependencies
echo "Installing dependencies..."
/opt/vcpkg/vcpkg install --triplet x64-linux --manifest

echo "VS-Compress setup complete!"
