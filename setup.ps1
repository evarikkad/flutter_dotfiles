# Run this in PowerShell as Admin

# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Output "Chocolatey is already installed!"
}

# Check and Install Java
$javaVersion = "17"
if (!(java -version 2>&1 | Select-String "openjdk $javaVersion")) {
    Write-Output "Installing Java $javaVersion..."
    choco install openjdk17 -y
} else {
    Write-Output "Java $javaVersion is already installed!"
}

# Check and Install Dart
if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Dart..."
    choco install dart-sdk -y
} else {
    Write-Output "Dart is already installed!"
}

# Check and Install Flutter
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Flutter..."
    choco install flutter -y
} else {
    Write-Output "Flutter is already installed!"
}

# Check and Sync VS Code settings
$settingsPath = "$env:APPDATA\Code\User\settings.json"
if (Test-Path $settingsPath) {
    Write-Output "VS Code settings already exist!"
} else {
    Write-Output "Syncing VS Code settings..."
    Copy-Item -Path "$HOME\dotfiles\vscode-settings.json" -Destination $settingsPath -Force
}

Write-Output "Setup complete! Restart PowerShell."
