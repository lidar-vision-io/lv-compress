param (
    [string]$InstallPath = "C:\vcpkg"
)

# Function to check if vcpkg is installed
function Check-Vcpkg {
    if ($env:VCPKG_ROOT -and (Test-Path "$env:VCPKG_ROOT\vcpkg.exe")) {
        return $env:VCPKG_ROOT
    }
    if (Test-Path "C:\vcpkg\vcpkg.exe") {
        return "C:\vcpkg"
    }
    if (Test-Path "$env:USERPROFILE\vcpkg\vcpkg.exe") {
        return "$env:USERPROFILE\vcpkg"
    }
    $vcpkgPath = (Get-Command vcpkg -ErrorAction SilentlyContinue).Source
    if ($vcpkgPath -and (Test-Path "$vcpkgPath")) {
        return Split-Path -Parent $vcpkgPath
    }
    return $null
}

# Check if vcpkg is already installed
$ExistingVcpkgPath = Check-Vcpkg

if ($ExistingVcpkgPath) {
    Write-Host "vcpkg is already installed at $ExistingVcpkgPath"
    $VcpkgInstallPath = $ExistingVcpkgPath
} else {
    # Use the user-provided install path (default to C:\vcpkg if none provided)
    $VcpkgInstallPath = $InstallPath
    Write-Host "vcpkg not found. Installing to $VcpkgInstallPath..."

    # Ensure the target directory exists
    if (!(Test-Path $VcpkgInstallPath)) {
        New-Item -ItemType Directory -Path $VcpkgInstallPath | Out-Null
    }

    # Clone vcpkg
    git clone https://github.com/microsoft/vcpkg.git $VcpkgInstallPath
}

Write-Host "Bootstrapping vcpkg..."
& "$VcpkgInstallPath\bootstrap-vcpkg.bat"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: vcpkg bootstrap failed."
    exit 1
}

# Ensure VCPKG_ROOT is set
$IsAdmin = [bool]([System.Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains "S-1-5-32-544"

if (!$IsAdmin) {
    Write-Host "Warning: Running without admin privileges. The environment variable VCPKG_ROOT will only be set for this session."
    $env:VCPKG_ROOT = $VcpkgInstallPath
} else {
    Write-Host "Setting VCPKG_ROOT system-wide..."
    [System.Environment]::SetEnvironmentVariable("VCPKG_ROOT", $VcpkgInstallPath, [System.EnvironmentVariableTarget]::Machine)
}

# Install dependencies
Write-Host "Installing dependencies..."
& "$VcpkgInstallPath\vcpkg.exe" install --triplet x64-windows

Write-Host "VS-Compress setup complete!"
