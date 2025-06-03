#!/bin/bash

# Terminator Setup Script for Ubuntu
# This script installs Terminator and sets up Ctrl+Alt+T to open it

set -e  # Exit on any error

echo "🚀 Setting up Terminator terminal emulator..."

# Check if running on Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    echo "❌ Error: This script is designed for Ubuntu/Debian systems with apt package manager"
    exit 1
fi

# Update package list
echo "📦 Updating package list..."
sudo apt update

# Install Terminator
echo "📥 Installing Terminator..."
if ! command -v terminator &> /dev/null; then
    sudo apt install -y terminator
    echo "✅ Terminator installed successfully"
else
    echo "ℹ️  Terminator is already installed"
fi

# Check if we're in a GUI environment
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    echo "⚠️  Warning: No GUI environment detected. Key bindings may not work until you log into a desktop session."
fi

# Disable the default terminal shortcut
echo "🔧 Configuring keyboard shortcuts..."
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"

# Set up custom shortcut for Terminator
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ name "Open Terminator"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ command "terminator"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ binding "<Primary><Alt>t"

# Get existing custom keybindings and add our new one
existing_keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
if [[ "$existing_keybindings" == "@as []" ]]; then
    # No existing custom keybindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/']"
else
    # Add to existing keybindings if not already present
    if [[ "$existing_keybindings" != *"terminator"* ]]; then
        # Remove the closing bracket and add our keybinding
        new_keybindings=$(echo "$existing_keybindings" | sed "s/]$/, '\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/terminator\/']/"  | sed "s/\[@as /[/")
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$new_keybindings"
    fi
fi

echo "✅ Keyboard shortcut configured successfully"

# Optional: Create a basic Terminator config for better UX
terminator_config_dir="$HOME/.config/terminator"
terminator_config_file="$terminator_config_dir/config"

if [ ! -f "$terminator_config_file" ]; then
    echo "⚙️  Creating basic Terminator configuration..."
    mkdir -p "$terminator_config_dir"
    cat > "$terminator_config_file" << 'EOF'
[global_config]
  enabled_plugins = LaunchpadCodeURLHandler, APTURLHandler, LaunchpadBugURLHandler
  suppress_multiple_term_dialog = True
  title_hide_sizetext = True
  title_transmit_fg_color = "#d30102"
  title_transmit_bg_color = "#ffffff"
  title_inactive_fg_color = "#000000"
  title_inactive_bg_color = "#c0bebf"
[keybindings]
[profiles]
  [[default]]
    background_color = "#1e1e1e"
    background_darkness = 0.95
    background_type = transparent
    cursor_color = "#ffffff"
    font = Monospace 11
    foreground_color = "#ffffff"
    show_titlebar = False
    scrollbar_position = hidden
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
EOF
    echo "✅ Basic Terminator configuration created"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Summary:"
echo "   • Terminator has been installed"
echo "   • Ctrl+Alt+T now opens Terminator instead of the default terminal"
echo "   • Basic configuration has been created"
echo ""
echo "💡 Usage tips:"
echo "   • Right-click in Terminator to split panes"
echo "   • Click between panes to switch focus"
echo "   • Drag borders to resize panes"
echo ""
echo "🔄 You may need to log out and back in for the shortcut to work properly"
echo "   Or try: killall gnome-shell (this will restart the shell)"
