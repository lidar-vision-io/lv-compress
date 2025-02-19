#!/bin/bash

check_vcpkg() {
    if [[ -n "$VCPKG_ROOT" ]]; then
        echo "$VCPKG_ROOT"
        return
    fi
    if [[ -d "/opt/vcpkg" ]]; then
        echo "/opt/vcpkg"
        return
    fi
    if [[ -d "$HOME/vcpkg" ]]; then
        echo "$HOME/vcpkg"
        return
    fi
    if command -v vcpkg &> /dev/null; then
        dirname "$(command -v vcpkg)"
        return
    fi
    echo ""
}

CUSTOM_VCPKG_PATH=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -path) CUSTOM_VCPKG_PATH="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Determine vcpkg installation path
VCPKG_INSTALL_PATH="${CUSTOM_VCPKG_PATH:-$(check_vcpkg)}"

# Install vcpkg if not found
if [[ -z "$VCPKG_INSTALL_PATH" ]]; then
    VCPKG_INSTALL_PATH="/opt/vcpkg"
    echo "vcpkg not found. Installing to $VCPKG_INSTALL_PATH..."
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_INSTALL_PATH"
    "$VCPKG_INSTALL_PATH/bootstrap-vcpkg.sh"
else
    echo "vcpkg detected at $VCPKG_INSTALL_PATH"
fi

# Set environment variable if not already set
if [[ -z "$VCPKG_ROOT" ]]; then
    export VCPKG_ROOT="$VCPKG_INSTALL_PATH"
    echo "VCPKG_ROOT set to $VCPKG_INSTALL_PATH"
fi

echo "Installing dependencies..."
"$VCPKG_INSTALL_PATH/vcpkg" install --triplet x64-linux --manifest

echo "VS-Compress setup complete!"