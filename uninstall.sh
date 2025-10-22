#!/usr/bin/env bash

# set -e

echo "🌤️  panahone weather applet uninstaller"
echo "========================================"
echo ""

read -p "are you sure you want to uninstall panahone? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "uninstallation cancelled."
    exit 0
fi

# rm symbolic link
if [ -L ~/.local/bin/panahone ]; then
    rm ~/.local/bin/panahone
    echo "✅ removed symbolic link from ~/.local/bin"
fi

# rm .desktop file
if [ -f ~/.local/share/applications/panahone.desktop ]; then
    rm ~/.local/share/applications/panahone.desktop
    echo "✅ removed desktop entry"
fi

# rm xdg autostart shenanigans
if [ -f ~/.config/autostart/panahone.desktop ]; then
    rm ~/.config/autostart/panahone.desktop
    echo "✅ removed autostart entry"
fi

echo ""
read -p "do you want to remove configuration and cache files? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d ~/.config/panahone ]; then
        rm -rf ~/.config/panahone
        echo "✅ removed configuration directory"
    fi

    if [ -d ~/.cache/panahone ]; then
        rm -rf ~/.cache/panahone
        echo "✅ removed cache directory"
    fi
fi

echo ""
echo "🎉 panahone has been uninstalled."
echo "you can manually remove the source directory if desired."