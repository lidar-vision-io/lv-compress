#!/bin/bash

# Default installation path
INSTALL_PATH="/opt/vcpkg"

# Function to check if vcpkg is installed
check_vcpkg() {
    if [[ -n "$VCPKG_ROOT" && -f "$VCPKG_ROOT/vcpkg" ]]; then
        echo "$VCPKG_ROOT"
        return
    fi
    if [[ -f "/opt/vcpkg/vcpkg" ]]; then
        echo "/opt/vcpkg"
        return
    fi
    if [[ -f "$HOME/vcpkg/vcpkg" ]]; then
        echo "$HOME/vcpkg"
        return
    fi
    if command -v vcpkg &> /dev/null; then
        dirname "$(command -v vcpkg)"
        return
    fi
    echo ""
}

# Parse CLI arguments for custom install path
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -path) INSTALL_PATH="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Check if vcpkg is already installed
EXISTING_VCPKG_PATH=$(check_vcpkg)

if [[ -n "$EXISTING_VCPKG_PATH" ]]; then
    echo "vcpkg is already installed at $EXISTING_VCPKG_PATH"
    VCPKG_INSTALL_PATH="$EXISTING_VCPKG_PATH"
else
    # Use the user-provided install path (or default to /opt/vcpkg)
    VCPKG_INSTALL_PATH="$INSTALL_PATH"
    echo "vcpkg not found. Installing to $VCPKG_INSTALL_PATH..."

    # Ensure the target directory exists
    mkdir -p "$VCPKG_INSTALL_PATH"

    # Clone vcpkg
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_INSTALL_PATH"
fi

# Run vcpkg bootstrap separately
echo "Bootstrapping vcpkg..."
"$VCPKG_INSTALL_PATH/bootstrap-vcpkg.sh"
if [[ $? -ne 0 ]]; then
    echo "Error: vcpkg bootstrap failed."
    exit 1
fi

# Ensure VCPKG_ROOT is set
if [[ -z "$VCPKG_ROOT" ]]; then
    export VCPKG_ROOT="$VCPKG_INSTALL_PATH"
    echo "VCPKG_ROOT set to $VCPKG_INSTALL_PATH"
fi

# Install dependencies
echo "Installing dependencies..."
"$VCPKG_INSTALL_PATH/vcpkg" install --triplet x64-linux

echo "VS-Compress setup complete!"