# Ensure running as Admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Please run as Administrator!"
    exit
}

# Check and install Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Output "Chocolatey is already installed!"
}

# Check Java version (allow 17 or higher)
$javaVersion = java -version 2>&1 | Select-String -Pattern '"(\d+)' | % { $_.Matches.Groups[1].Value } | Select-Object -First 1
if (-not $javaVersion -or [int]$javaVersion -lt 17) {
    Write-Output "Installing Java (17 or higher)..."
    choco install openjdk -y
} else {
    Write-Output "Java $javaVersion already installed!"
}

# Install Dart & Flutter
foreach ($pkg in "dart-sdk", "flutter") {
    if (-not (Get-Command $pkg -ErrorAction SilentlyContinue)) {
        Write-Output "Installing $pkg..."
        choco install $pkg -y
    } else {
        Write-Output "$pkg is already installed!"
    }
}

# Sync VS Code settings
$settingsPath = "$env:APPDATA\Code\User\settings.json"
if (-not (Test-Path $settingsPath)) {
    Write-Output "Syncing VS Code settings..."
    Copy-Item -Path "$HOME\flutter_dotfiles\vscode-settings.json" -Destination $settingsPath -Force
} else {
    Write-Output "VS Code settings already exist!"
}

Write-Output "Setup complete! Restart PowerShell."
