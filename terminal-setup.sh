#!/bin/bash

# Terminator Setup Script for Ubuntu
# This script installs Terminator and sets up Ctrl+Alt+T to open it

set -e  # Exit on any error

# Check for revert flag
if [ "$1" = "--revert" ] || [ "$1" = "-r" ]; then
    echo "🔄 Reverting all changes made by this script..."
    
    # Revert keyboard shortcut to default terminal
    echo "⌨️  Restoring default terminal shortcut..."
    
    # First, restore the default terminal shortcut
    gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']"
    
    # Remove custom terminator shortcut completely
    existing_keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    if [[ "$existing_keybindings" == *"terminator"* ]]; then
        echo "🗑️  Removing custom Terminator keybinding..."
        
        # Remove terminator keybinding from the list
        new_keybindings=$(echo "$existing_keybindings" | sed "s/, '\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/terminator\/'//g" | sed "s/'\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/terminator\/', //g" | sed "s/'\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/terminator\/'//g")
        
        # Handle case where it might be the only keybinding
        if [[ "$new_keybindings" == "[@as ]" ]] || [[ "$new_keybindings" == "[]" ]]; then
            new_keybindings="@as []"
        fi
        
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$new_keybindings"
        
        # Remove the terminator keybinding configuration
        gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ name 2>/dev/null || true
        gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ command 2>/dev/null || true
        gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ binding 2>/dev/null || true
        
        echo "✅ Terminator keybinding removed"
    fi
    
    echo "✅ Default terminal shortcut restored"
    
    # Restore bashrc from backup
    latest_bashrc_backup=$(ls -t "$HOME/.bashrc.backup"* 2>/dev/null | head -1)
    if [ -n "$latest_bashrc_backup" ]; then
        echo "📝 Restoring .bashrc from backup: $(basename "$latest_bashrc_backup")"
        cp "$latest_bashrc_backup" "$HOME/.bashrc"
        echo "✅ .bashrc restored from backup"
    else
        echo "⚠️  No .bashrc backup found - removing Git prompt manually..."
        # More aggressive cleanup of Git prompt
        cp "$HOME/.bashrc" "$HOME/.bashrc.temp"
        sed '/# Git-aware prompt function/,/export PS1.*git_branch.*$/d' "$HOME/.bashrc.temp" > "$HOME/.bashrc"
        rm "$HOME/.bashrc.temp"
        
        # Also remove any orphaned git_branch function calls
        sed -i '/git_branch/d' "$HOME/.bashrc" 2>/dev/null || true
        sed -i '/\$(git_branch)/d' "$HOME/.bashrc" 2>/dev/null || true
        
        echo "✅ Git prompt removed manually"
    fi
    
    # Restore inputrc from backup
    latest_inputrc_backup=$(ls -t "$HOME/.inputrc.backup"* 2>/dev/null | head -1)
    if [ -n "$latest_inputrc_backup" ]; then
        echo "⌨️  Restoring .inputrc from backup: $(basename "$latest_inputrc_backup")"
        cp "$latest_inputrc_backup" "$HOME/.inputrc"
    else
        if [ -f "$HOME/.inputrc" ]; then
            echo "⚠️  No .inputrc backup found - removing enhanced shortcuts file..."
            rm "$HOME/.inputrc"
            echo "📝 Removed custom .inputrc (system will use defaults)"
        fi
    fi
    
    # Restore terminator config from backup
    terminator_config_file="$HOME/.config/terminator/config"
    latest_terminator_backup=$(ls -t "$terminator_config_file.backup"* 2>/dev/null | head -1)
    if [ -n "$latest_terminator_backup" ]; then
        echo "🎨 Restoring Terminator config from backup: $(basename "$latest_terminator_backup")"
        cp "$latest_terminator_backup" "$terminator_config_file"
    else
        if [ -f "$terminator_config_file" ]; then
            echo "⚠️  No Terminator backup found - removing custom config..."
            rm "$terminator_config_file"
            echo "📝 Removed custom Terminator config (will use defaults)"
        fi
    fi
    
    echo ""
    echo "✅ Revert completed successfully!"
    echo ""
    echo "📋 What was reverted:"
    echo "   • Ctrl+Alt+T now opens default terminal again"
    echo "   • Bash prompt restored (no more Git branch info)"
    echo "   • Terminal shortcuts restored to defaults"
    echo "   • Terminator config restored or removed"
    echo ""
    echo "📦 Terminator is still installed but no longer configured"
    echo "   To completely remove: sudo apt remove terminator"
    echo ""
    echo "🔄 Restarting desktop environment to apply changes..."
    
    # Restart desktop environment to ensure all changes take effect
    if command -v gnome-shell &> /dev/null; then
        # GNOME desktop environment
        echo "🖥️  Detected GNOME - restarting shell..."
        # Use nohup to prevent the command from being killed when terminal closes
        nohup bash -c 'sleep 2 && killall gnome-shell' >/dev/null 2>&1 &
        echo "✅ Desktop restart initiated - your desktop will reload in 2 seconds"
    elif [ "$XDG_CURRENT_DESKTOP" = "Unity" ]; then
        # Unity desktop environment  
        echo "🖥️  Detected Unity - restarting..."
        nohup bash -c 'sleep 2 && restart unity' >/dev/null 2>&1 &
        echo "✅ Desktop restart initiated"
    elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "kde-plasma" ]; then
        # KDE desktop environment
        echo "🖥️  Detected KDE - restarting..."
        nohup bash -c 'sleep 2 && kquitapp5 plasmashell && kstart5 plasmashell' >/dev/null 2>&1 &
        echo "✅ Desktop restart initiated"
    else
        echo "🖥️  Desktop environment not automatically detected"
        echo "🔄 You may need to:"
        echo "   - Log out and back in"
        echo "   - Or restart manually: killall gnome-shell (for GNOME)"
        echo "   - Or reboot if changes don't apply"
    fi
    
    echo ""
    echo "🎉 Revert complete! After desktop restart:"
    echo "   - Press Ctrl+Alt+T to test (should open default terminal)" 
    echo "   - Your prompt should be back to normal"
    
    exit 0
fi

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

# Create a backup of existing bashrc (only if no recent backup exists)
if [ -f "$HOME/.bashrc" ]; then
    latest_backup=$(ls -t "$HOME/.bashrc.backup"* 2>/dev/null | head -1)
    if [ -z "$latest_backup" ] || [ "$HOME/.bashrc" -nt "$latest_backup" ]; then
        cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%s)"
        echo "📝 Backed up existing .bashrc"
    else
        echo "📝 Recent backup exists, skipping backup"
    fi
fi

# Remove any existing Git prompt configuration to avoid duplicates
echo "🧹 Cleaning up any existing Git prompt configuration..."
sed -i '/# Git-aware prompt function/,/^$/d' "$HOME/.bashrc" 2>/dev/null || true
sed -i '/git_branch()/,/^}/d' "$HOME/.bashrc" 2>/dev/null || true
sed -i '/export PS1.*git_branch/d' "$HOME/.bashrc" 2>/dev/null || true

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
        echo " [no git repo]"
    fi
}

# Custom prompt with Git branch info
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(git_branch)\[\033[00m\]\$ '
EOF

echo "✅ Git-aware prompt configured in ~/.bashrc"

# Configure enhanced readline shortcuts for better text editing
echo "⌨️  Setting up enhanced terminal shortcuts..."

# Create backup of existing .inputrc (only if no recent backup exists)
if [ -f "$HOME/.inputrc" ]; then
    latest_inputrc_backup=$(ls -t "$HOME/.inputrc.backup"* 2>/dev/null | head -1)
    if [ -z "$latest_inputrc_backup" ] || [ "$HOME/.inputrc" -nt "$latest_inputrc_backup" ]; then
        cp "$HOME/.inputrc" "$HOME/.inputrc.backup.$(date +%s)"
        echo "📝 Backed up existing .inputrc"
    else
        echo "📝 Recent .inputrc backup exists, skipping backup"
    fi
fi

# Create or update .inputrc for readline shortcuts
cat > "$HOME/.inputrc" << 'EOF'
# Enhanced terminal shortcuts matching standard word navigation

# Ctrl+Backspace: Delete word backward
"\C-h": backward-kill-word

# Ctrl+Delete: Delete word forward  
"\e[3;5~": kill-word

# Alt+Backspace: Delete word backward (alternative)
"\e\C-h": backward-kill-word

# Ctrl+Left: Move cursor backward one word
"\e[1;5D": backward-word

# Ctrl+Right: Move cursor forward one word
"\e[1;5C": forward-word

# Home: Go to beginning of line
"\e[H": beginning-of-line
"\e[1~": beginning-of-line

# End: Go to end of line
"\e[F": end-of-line
"\e[4~": end-of-line

# Fn+Home (Ctrl+Home): Go to beginning of line
"\e[1;5H": beginning-of-line

# Fn+End (Ctrl+End): Go to end of line
"\e[1;5F": end-of-line

# Ctrl+A: Go to beginning of line (keep familiar shortcut)
"\C-a": beginning-of-line

# Ctrl+E: Go to end of line (keep familiar shortcut)
"\C-e": end-of-line

# Ctrl+U: Clear entire line
"\C-u": unix-line-discard

# Ctrl+K: Clear from cursor to end of line
"\C-k": kill-line

# Ctrl+W: Delete word backward (alternative to Ctrl+Backspace)
"\C-w": backward-kill-word

# Enable case-insensitive tab completion
set completion-ignore-case on

# Show completion matches immediately
set show-all-if-ambiguous on

# Use colored completion
set colored-stats on
set colored-completion-prefix on
EOF

echo "✅ Enhanced terminal shortcuts configured in ~/.inputrc"
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
echo "🎉 Setup complete! (Safe to re-run anytime for updates)"
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
echo "   3. Run 'source ~/.bashrc' or start a new terminal to see Git prompt and shortcuts"
echo "   4. If colors still don't apply, run: terminator --new-tab"
echo ""
echo "🔧 To manually reload config: Close Terminator completely and reopen"
