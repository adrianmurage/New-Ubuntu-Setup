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

# Always create/overwrite Terminator config to ensure settings apply
echo "⚙️  Creating Terminator configuration..."
mkdir -p "$terminator_config_dir"

# Remove existing config to force refresh
if [ -f "$terminator_config_file" ]; then
    echo "📝 Backing up existing config..."
    cp "$terminator_config_file" "$terminator_config_file.backup.$(date +%s)"
fi

cat > "$terminator_config_file" << 'EOF'
[global_config]
  enabled_plugins = LaunchpadCodeURLHandler, APTURLHandler, LaunchpadBugURLHandler
  suppress_multiple_term_dialog = True
  title_hide_sizetext = True
  title_transmit_fg_color = "#ffffff"
  title_transmit_bg_color = "#333333"
  title_inactive_fg_color = "#cccccc"
  title_inactive_bg_color = "#1e1e1e"
  window_state = maximise
[keybindings]
  split_horiz = <Primary>backslash
  split_vert = <Primary>apostrophe
[profiles]
  [[default]]
    background_color = "#1e1e1e"
    background_darkness = 0.9
    background_type = transparent
    cursor_blink = False
    cursor_color = "#ffffff"
    cursor_shape = block
    font = Monospace 12
    foreground_color = "#ffffff"
    show_titlebar = False
    scrollbar_position = hidden
    scrollback_infinite = True
    use_system_font = False
    copy_on_selection = True
    palette = "#000000:#cc0000:#4e9a06:#c4a000:#3465a4:#75507b:#06989a:#d3d7cf:#555753:#ef2929:#8ae234:#fce94f:#729fcf:#ad7fa8:#34e2e2:#eeeeec"
    bold_is_bright = True
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
      size = 1200, 800
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = default
[plugins]
EOF

echo "✅ Terminator configuration created with proper theming and keybindings"

# Configure Git-aware bash prompt
echo "🌿 Setting up Git-aware bash prompt..."

# Create a backup of existing bashrc
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%s)"
    echo "📝 Backed up existing .bashrc"
fi

# Add Git prompt function to bashrc
cat >> "$HOME/.bashrc" << 'EOF'

# Git-aware prompt function
git_branch() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
        if [ -n "$branch" ]; then
            echo " [$branch]"
        else
            echo " [no branch]"
        fi
    else
        echo " [no git repository]"
    fi
}

# Custom prompt with Git branch info
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(git_branch)\[\033[00m\]\$ '
EOF

echo "✅ Git-aware prompt configured in ~/.bashrc"
echo ""
echo "🎯 Custom shortcuts configured:"
echo "   • Ctrl + \\ (backslash/pipe key) = Split vertically"
echo "   • Ctrl + ' (apostrophe/quote key) = Split horizontally"
echo ""

# Display the actual config for verification
echo "📋 Keybinding section in config:"
grep -A 3 "\[keybindings\]" "$terminator_config_file" || echo "Could not read keybindings from config"

# Kill any running Terminator instances to force config reload
if pgrep terminator > /dev/null; then
    echo "🔄 Restarting Terminator to apply new configuration..."
    pkill terminator
    sleep 1
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
echo "🔄 You may need to:"
echo "   1. Close all Terminator windows"
echo "   2. Press Ctrl+Alt+T to open a new Terminator with the updated theme"
echo "   3. Run 'source ~/.bashrc' or start a new terminal session to see Git prompt"
echo "   4. If colors still don't apply, run: terminator --new-tab"
echo ""
echo "🔧 To manually reload config: Close Terminator completely and reopen"
