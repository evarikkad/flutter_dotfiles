#!/bin/bash

# Detect OS and Architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected OS: $OS, Architecture: $ARCH"

# Check if Homebrew is installed (for macOS/Linux ARM)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed!"
fi

# Install Java (Example: OpenJDK 17)
export JAVA_VERSION=17
if [[ "$OS" == "Darwin" ]]; then
    if ! brew list | grep -q "openjdk@$JAVA_VERSION"; then
        echo "Installing Java $JAVA_VERSION..."
        brew install openjdk@$JAVA_VERSION
    else
        echo "Java $JAVA_VERSION is already installed!"
    fi
elif [[ "$OS" == "Linux" ]]; then
    if ! java -version 2>&1 | grep -q "openjdk $JAVA_VERSION"; then
        echo "Installing Java $JAVA_VERSION..."
        sudo apt update && sudo apt install -y openjdk-$JAVA_VERSION-jdk
    else
        echo "Java $JAVA_VERSION is already installed!"
    fi
fi

# Install Dart & Flutter
if [[ "$OS" == "Darwin" ]]; then
    if ! command -v dart &> /dev/null; then
        echo "Installing Dart..."
        brew install dart
    else
        echo "Dart is already installed!"
    fi

    if ! command -v flutter &> /dev/null; then
        echo "Installing Flutter..."
        brew install flutter
    else
        echo "Flutter is already installed!"
    fi
elif [[ "$OS" == "Linux" ]]; then
    if ! command -v dart &> /dev/null; then
        echo "Installing Dart..."
        sudo apt update && sudo apt install dart -y
    else
        echo "Dart is already installed!"
    fi

    if ! command -v flutter &> /dev/null; then
        echo "Installing Flutter..."
        git clone https://github.com/flutter/flutter.git ~/flutter
        echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc
    else
        echo "Flutter is already installed!"
    fi
fi

# Sync VS Code settings
if [ -f ~/.config/Code/User/settings.json ]; then
    echo "VS Code settings already exist!"
else
    echo "Syncing VS Code settings..."
    mkdir -p ~/.config/Code/User
    ln -sf ~/dotfiles/vscode-settings.json ~/.config/Code/User/settings.json
fi

echo "Setup complete! Restart your terminal."
