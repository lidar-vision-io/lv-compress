if (!(Test-Path "C:\vcpkg")) {
    Write-Host "Installing vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git C:\vcpkg
    & C:\vcpkg\bootstrap-vcpkg.bat
}

# Set environment variable
[System.Environment]::SetEnvironmentVariable("VCPKG_ROOT", "C:\vcpkg", [System.EnvironmentVariableTarget]::Machine)

# Install dependencies
Write-Host "Installing dependencies..."
& C:\vcpkg\vcpkg install --triplet x64-windows --manifest

Write-Host "VS-Compress setup complete!"
