#!/bin/bash

# Detect OS and Architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected OS: $OS, Architecture: $ARCH"

# Install Homebrew if not installed (Mac/Linux ARM)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed!"
fi

# Check Java version (allow 17 or higher)
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d. -f1)
if [[ -z "$JAVA_VERSION" || "$JAVA_VERSION" -lt 17 ]]; then
    echo "Installing Java (17 or higher)..."
    brew install openjdk@17
else
    echo "Java $JAVA_VERSION already installed!"
fi

# Install Dart & Flutter
for pkg in dart flutter; do
    if ! command -v $pkg &> /dev/null; then
        echo "Installing $pkg..."
        brew install $pkg
    else
        echo "$pkg is already installed!"
    fi
done

# Sync VS Code settings
mkdir -p ~/.config/Code/User
ln -sf ~/flutter_dotfiles/vscode-settings.json ~/.config/Code/User/settings.json

echo "Setup complete! Restart your terminal."
