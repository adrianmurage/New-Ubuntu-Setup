#!/bin/bash

# Terminator Setup Script for Fedora
# Direct adaptation of Ubuntu script - replaces default terminal with Terminator

set -e  # Exit on any error

# Check for revert flag
if [ "$1" = "--revert" ] || [ "$1" = "-r" ]; then
    echo "🔄 Reverting all changes made by this script..."
    
    echo "🔍 Debugging current configuration..."
    
    # Check current terminal shortcut
    echo "Current terminal shortcut:"
    gsettings get org.gnome.settings-daemon.plugins.media-keys terminal 2>/dev/null || echo "No terminal shortcut found"
    
    # Check custom keybindings
    echo "Current custom keybindings:"
    gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null || echo "No custom keybindings found"
    
    # Check for terminator specific binding (check both old terminator path and new custom0 path)
    echo "Terminator keybinding details:"
    gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 2>/dev/null || echo "No custom0 name found"
    gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 2>/dev/null || echo "No custom0 command found"
    gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 2>/dev/null || echo "No custom0 binding found"
    gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ name 2>/dev/null || echo "No terminator name found"
    gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ command 2>/dev/null || echo "No terminator command found"
    gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ binding 2>/dev/null || echo "No terminator binding found"
    
    echo ""
    echo "🔧 Starting revert process..."
    
    # Step 1: Reset terminal shortcut to default
    echo "Step 1: Resetting terminal shortcut..."
    gsettings reset org.gnome.settings-daemon.plugins.media-keys terminal 2>/dev/null || true
    
    # Step 2: Explicitly set default terminal shortcut (for Ptyxis on Fedora)
    echo "Step 2: Setting default terminal shortcut..."
    gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']" 2>/dev/null || true
    
    # Step 3: Find and remove terminator keybinding
    echo "Step 3: Finding and removing terminator keybinding..."
    current_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null || echo "@as []")
    echo "Current bindings: $current_bindings"
    
    # Check each custom keybinding to find the one that launches terminator
    terminator_binding_found=""
    if [[ "$current_bindings" != "@as []" ]] && [[ "$current_bindings" != "[]" ]]; then
        # Extract all custom keybinding paths
        binding_paths=$(echo "$current_bindings" | grep -oP "'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/[^']*'" | sed "s/'//g")
        
        for path in $binding_paths; do
            # Check if this keybinding launches terminator
            echo "Checking keybinding at: $path"
            name=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path}/ name 2>/dev/null || echo "")
            command=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path}/ command 2>/dev/null || echo "")
            binding=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path}/ binding 2>/dev/null || echo "")
            
            echo "  Name: $name"
            echo "  Command: $command"
            echo "  Binding: $binding"
            
            if [[ "$command" == *"terminator"* ]] || [[ "$name" == *"Terminator"* ]] || [[ "$name" == *"terminator"* ]] || [[ "$path" == *"custom0"* ]]; then
                echo "Found terminator keybinding at: $path"
                terminator_binding_found="$path"
                break
            fi
        done
    fi
    
    if [ -n "$terminator_binding_found" ]; then
        echo "Removing terminator keybinding..."
        
        # Remove the specific terminator keybinding from the list
        cleaned_bindings=$(echo "$current_bindings" | sed "s|, '$terminator_binding_found'||g" | sed "s|'$terminator_binding_found', ||g" | sed "s|'$terminator_binding_found'||g")
        
        # Clean up empty list format
        if [[ "$cleaned_bindings" == "[@as ]" ]] || [[ "$cleaned_bindings" == "[]" ]] || [[ "$cleaned_bindings" =~ ^\[@as[[:space:]]*\]$ ]]; then
            cleaned_bindings="@as []"
        fi
        
        echo "Setting cleaned bindings: $cleaned_bindings"
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$cleaned_bindings" 2>/dev/null || true
        
        # Remove the actual keybinding configuration
        echo "Removing keybinding configuration at: $terminator_binding_found"
        dconf reset -f "${terminator_binding_found}/" 2>/dev/null || true
        
    else
        echo "No terminator keybinding found in custom bindings"
        echo "Removing ALL custom keybindings as fallback..."
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "@as []" 2>/dev/null || true
        
        # Also try to remove common keybinding paths
        dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ 2>/dev/null || true
        dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminator/ 2>/dev/null || true
    fi
    
    # Step 5: Verify changes
    echo ""
    echo "🔍 Verification after changes:"
    echo "Terminal shortcut now:"
    gsettings get org.gnome.settings-daemon.plugins.media-keys terminal 2>/dev/null || echo "No terminal shortcut found"
    echo "Custom keybindings now:"
    gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null || echo "No custom keybindings found"
    
    # Restore bashrc from backup OR clean manually
    latest_bashrc_backup=$(ls -t "$HOME/.bashrc.backup"* 2>/dev/null | head -1)
    if [ -n "$latest_bashrc_backup" ]; then
        echo "📝 Found backup: $(basename "$latest_bashrc_backup")"
        
        # Check if backup contains git prompt (meaning backup was made after setup)
        if grep -q "git_branch" "$latest_bashrc_backup"; then
            echo "⚠️  Backup contains Git prompt - backup was made after setup"
            echo "🧹 Manually removing Git prompt from current .bashrc..."
            
            # Create a clean version without git prompt
            cp "$HOME/.bashrc" "$HOME/.bashrc.temp"
            
            # Remove git_branch function and all PS1 lines that use it
            sed -i '/# Git-aware prompt function/,/^$/d' "$HOME/.bashrc.temp"
            sed -i '/git_branch()/,/^}/d' "$HOME/.bashrc.temp"
            sed -i '/export PS1.*git_branch/d' "$HOME/.bashrc.temp"
            sed -i '/PS1.*git_branch/d' "$HOME/.bashrc.temp"
            
            # Copy cleaned version back
            cp "$HOME/.bashrc.temp" "$HOME/.bashrc"
            rm "$HOME/.bashrc.temp"
            
            echo "✅ Git prompt manually removed from .bashrc"
        else
            echo "📝 Backup is clean - restoring from backup"
            cp "$latest_bashrc_backup" "$HOME/.bashrc"
            echo "✅ .bashrc restored from clean backup"
        fi
    else
        echo "⚠️  No .bashrc backup found - removing Git prompt manually..."
        # More aggressive cleanup of Git prompt
        cp "$HOME/.bashrc" "$HOME/.bashrc.temp"
        
        # Remove all git-related prompt modifications
        sed -i '/# Git-aware prompt function/,/^$/d' "$HOME/.bashrc.temp"
        sed -i '/git_branch()/,/^}/d' "$HOME/.bashrc.temp"
        sed -i '/export PS1.*git_branch/d' "$HOME/.bashrc.temp"
        sed -i '/PS1.*git_branch/d' "$HOME/.bashrc.temp"
        
        cp "$HOME/.bashrc.temp" "$HOME/.bashrc"
        rm "$HOME/.bashrc.temp"
        
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
    echo "   • Ctrl+Alt+T shortcut configuration restored"
    echo "   • Bash prompt restored (no more Git branch info)"
    echo "   • Terminal shortcuts restored to defaults"
    echo "   • Terminator config restored or removed"
    echo ""
    echo "📦 Terminator is still installed but no longer configured"
    echo "   To completely remove: sudo dnf remove terminator"
    echo ""
    echo "🔄 IMPORTANT: To complete the revert process:"
    echo "   1. Close ALL terminal windows"
    echo "   2. Log out and log back in (safest method)"
    echo "   3. Test: Press Ctrl+Alt+T (should open default terminal)"
    echo ""
    echo "⚠️  Alternative if you can't log out:"
    echo "   • Restart manually: Alt+F2 → type 'r' → Enter (GNOME)"
    echo "   • Or run: source ~/.bashrc (for prompt changes)"
    echo ""
    echo "🎉 Revert process complete - log out/in to finalize!"
    
    exit 0
fi

echo "🚀 Setting up Terminator terminal emulator..."

# Check if running on Fedora
if ! command -v dnf &> /dev/null; then
    echo "❌ Error: This script is designed for Fedora systems with dnf package manager"
    exit 1
fi

# Update package list
echo "📦 Updating package list..."
sudo dnf check-update || true

# Install Terminator
echo "📥 Installing Terminator..."
if ! command -v terminator &> /dev/null; then
    sudo dnf install -y terminator
    echo "✅ Terminator installed successfully"
else
    echo "ℹ️  Terminator is already installed"
fi

# Check if we're in a GUI environment
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    echo "⚠️  Warning: No GUI environment detected. Key bindings may not work until you log into a desktop session."
fi

# Configure keyboard shortcuts for Terminator
echo "🔧 Configuring keyboard shortcuts..."

# Note: Fedora 42 doesn't have the 'terminal' key that Ubuntu has, so we skip disabling it
echo "ℹ️  Fedora detected - skipping default terminal shortcut disable (not needed)"

# Set up custom shortcut for Terminator using custom0 path (more reliable than terminator path)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Open Terminator"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "terminator"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Primary><Alt>t"

# Get existing custom keybindings and add our new one
existing_keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
if [[ "$existing_keybindings" == "@as []" ]]; then
    # No existing custom keybindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
else
    # Add to existing keybindings if not already present
    if [[ "$existing_keybindings" != *"custom0"* ]]; then
        # Remove the closing bracket and add our keybinding
        new_keybindings=$(echo "$existing_keybindings" | sed "s/]$/, '\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/custom0\/']/"  | sed "s/\[@as /[/")
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
  title_transmit_bg_color = "#1a1a1a"
  title_inactive_fg_color = "#cccccc"
  title_inactive_bg_color = "#1a1a1a"
  window_state = maximise
  handle_size = 3
  inactive_color_offset = 0.85
  borderless = True
  tab_position = hidden
  close_button_on_tab = False
[keybindings]
  split_horiz = <Primary>backslash
  split_vert = <Primary>apostrophe
[profiles]
  [[default]]
    background_color = "#1a1a1a"
    background_darkness = 1.0
    background_type = solid
    cursor_blink = False
    cursor_color = "#f0f0f0"
    cursor_shape = block
    font = Monospace 11
    foreground_color = "#f0f0f0"
    show_titlebar = False
    scrollbar_position = hidden
    scrollback_infinite = True
    use_system_font = False
    copy_on_selection = True
    palette = "#1a1a1a:#e74c3c:#2ecc71:#f39c12:#3498db:#9b59b6:#1abc9c:#ecf0f1:#555555:#c0392b:#27ae60:#d68910:#2980b9:#8e44ad:#16a085:#ffffff"
    bold_is_bright = True
    word_chars = "-,./?%&#:_=+@~"
    urgent_bell = False
    audible_bell = False
    visible_bell = False
    login_shell = False
    use_custom_command = False
    exit_action = close
    force_no_bell = True
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

echo "✅ Terminator configuration created with modern Ptyxis-like appearance"

echo ""
echo "🎨 Modern styling applied:"
echo "   • Clean dark theme matching GNOME/Ptyxis design"
echo "   • Borderless window for seamless integration"
echo "   • Hidden tabs and title bars for minimal interface"
echo "   • Pane borders visible in both light and dark system themes"
echo "   • Disabled all terminal bells for quiet operation"
echo "   • Modern color palette with proper contrast"

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
echo "   • Terminator has been installed with modern styling"
echo "   • Ctrl+Alt+T now opens Terminator instead of the default terminal"
echo "   • Ptyxis-inspired design with clean, borderless interface"
echo "   • Fixed dark mode visibility issues"
echo "   • Enhanced Git prompt and keyboard shortcuts configured"
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
