param (
    [string]$CustomVcpkgPath
)

function Check-Vcpkg {
    if ($env:VCPKG_ROOT) {
        return $env:VCPKG_ROOT
    }
    if (Test-Path "C:\vcpkg") {
        return "C:\vcpkg"
    }
    if (Test-Path "$env:USERPROFILE\vcpkg") {
        return "$env:USERPROFILE\vcpkg"
    }
    $vcpkgPath = (Get-Command vcpkg -ErrorAction SilentlyContinue).Source
    if ($vcpkgPath) {
        return Split-Path -Parent $vcpkgPath
    }
    return $null
}

# Determine vcpkg installation path
$VcpkgInstallPath = if ($CustomVcpkgPath) { $CustomVcpkgPath } else { Check-Vcpkg }

# Install vcpkg if not found
if (!$VcpkgInstallPath) {
    $VcpkgInstallPath = "C:\vcpkg"
    Write-Host "vcpkg not found. Installing to $VcpkgInstallPath..."
    git clone https://github.com/microsoft/vcpkg.git $VcpkgInstallPath
    & $VcpkgInstallPath\bootstrap-vcpkg.bat
} else {
    Write-Host "vcpkg detected at $VcpkgInstallPath"
}

# Set environment variable if not already set
if (!$env:VCPKG_ROOT) {
    [System.Environment]::SetEnvironmentVariable("VCPKG_ROOT", $VcpkgInstallPath, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "VCPKG_ROOT set to $VcpkgInstallPath"
}

# Install dependencies
Write-Host "Installing dependencies..."
& $VcpkgInstallPath\vcpkg install --triplet x64-windows --manifest

Write-Host "VS-Compress setup complete!"
