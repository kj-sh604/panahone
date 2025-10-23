#!/usr/bin/env bash

set -e

echo "🌤️  panahone weather applet installer"
echo "======================================"
echo ""

# checks
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "❌ error: this app is designed for linux systems."
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo "❌ error: python 3 is not installed."
    echo "please install python 3 first."
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "✅ python 3 found: $(python3 --version)"

if ! python3 -c "import gi; gi.require_version('Gtk', '3.0')" 2>/dev/null; then
    echo "⚠️  gtk3 python bindings not found."
    echo ""
    echo "please install the required system packages:"
    echo ""
    echo "Arch:"
    echo "  sudo pacman -S python-gobject gtk3 libnotify"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt install python3-gi gir1.2-gtk-3.0 gir1.2-notify-0.7"
    echo ""
    echo "Fedora:"
    echo "  sudo dnf install python3-gobject gtk3 libnotify"
    echo ""
    read -p "press enter to continue after installing, or ctrl+c to exit..."
fi

# deps check
echo ""
echo "📦 installing python dependencies..."
cd src
pip3 install --user -r requirements.txt

if [ $? -eq 0 ]; then
    echo "✅ dependencies installed successfully"
else
    echo "❌ failed to install dependencies"
    exit 1
fi

# +x check
chmod +x panahone
echo "✅ made panahone executable"

# symbolic link (my personal preferred)
echo ""
read -p "do you want to create a symbolic link in ~/.local/bin? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkdir -p ~/.local/bin
    ln -sf "$(pwd)/panahone" ~/.local/bin/panahone
    echo "✅ symbolic link created at ~/.local/bin/panahone"
    echo ""
    echo "⚠️  make sure ~/.local/bin is in your path:"
    echo "   add this to your ~/.bashrc or ~/.zshrc:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# .desktop file (i do not prefer this, personally but y'all go ahead!)
echo ""
read -p "do you want to create a desktop entry? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    DESKTOP_FILE="$HOME/.local/share/applications/panahone.desktop"
    mkdir -p ~/.local/share/applications

    cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Panahone
Comment=GTK3 Weather Applet
Exec=$(pwd)/panahone
Icon=weather-overcast
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=false
EOF

    echo "✅ desktop entry created at $desktop_file"
fi

# xdg autostart
echo ""
read -p "do you want panahone to start automatically on login? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    AUTOSTART_FILE="$HOME/.config/autostart/panahone.desktop"
    mkdir -p ~/.config/autostart

    cat >"$AUTOSTART_FILE" <<EOF
[Desktop Entry]
Name=Panahone
Comment=GTK3 Weather Applet
Exec=$(pwd)/panahone
Icon=weather-overcast
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF

    echo "✅ autostart entry created at $autostart_file"
fi

echo ""
echo "🎉 installation complete!"
echo ""
echo "you can now run panahone with:"
echo "  cd $(pwd) && ./panahone"
if [[ -L ~/.local/bin/panahone ]]; then
    echo "  or simply: panahone (if ~/.local/bin is in PATH)"
fi
echo ""
echo "for usage, run:"
echo "  ./panahone --help"
echo ""