### DNF Package Management
- **Fedora package manager** - Uses `dnf` instead of `apt`
- **Optimized installation** - Faster package resolution and installation
- **Better error handling** - Graceful handling of Fedora-specific package conflicts# Fresh Linux Setup Scripts

A collection of comprehensive scripts to set up a productive Linux environment. This repository contains focused setup scripts for different aspects of your Ubuntu or Fedora installation.

## 🐧 Supported Operating Systems

### Ubuntu/Debian Support
- **Ubuntu 18.04+** or any **Debian-based** distribution
- Uses `apt` package manager
- Original script with comprehensive testing

### Fedora Support 🆕
- **Fedora 35+** (tested on Fedora 42)
- Uses `dnf` package manager  
- Includes **Ptyxis terminal** support (Fedora's default)
- **Fixed pane divider visibility** in dark mode

## 📦 Available Scripts

### 🖥️ Terminal Setup
Choose the script for your operating system:
- **`terminal-setup.sh`** - Ubuntu/Debian version
- **`fedora-terminal-setup.sh`** - Fedora version 🆕

Both scripts provide the same enhanced terminal experience with platform-specific optimizations.

## 🚀 What the Terminal Setup Scripts Do

### Terminal Emulator Enhancement
- **Installs Terminator** - A powerful terminal emulator with splitting capabilities
- **Replaces Ctrl+Alt+T shortcut** - Opens Terminator instead of default terminal
- **Modern Ptyxis-inspired design** - Clean, borderless interface matching GNOME
- **Enhanced splitting** - Easy pane management with intuitive shortcuts
- **🔧 Fedora-specific**: Fixed keyboard shortcut logic and modern styling
- **🔧 Fedora-specific**: Seamless integration with GNOME desktop environment

### Git Integration
- **Git-aware prompt** - Shows current branch or "no git repo" status
- **Colored prompt** - Easy-to-read terminal prompt with visual hierarchy
- **Branch tracking** - Always know which branch you're working on

### Productivity Shortcuts
- **Word-level navigation** - Ctrl+Left/Right to move by words
- **Smart deletion** - Ctrl+Backspace to delete entire words
- **Standard shortcuts** - Home/End, Fn+Home/End for line navigation
- **Enhanced editing** - Modern text editing shortcuts in terminal

### Terminal Features
- **Split panes** - Ctrl+\ (horizontal) and Ctrl+' (vertical)
- **Mouse support** - Click between panes to switch focus
- **Modern interface** - Clean, borderless design matching GNOME aesthetics
- **Intelligent tab completion** - Case-insensitive with colored results
- **🔧 Fedora-specific**: Modern Ptyxis-inspired styling with seamless GNOME integration
- **🔧 Fedora-specific**: Visible pane dividers in both light and dark system themes

## 📋 Requirements

### Ubuntu/Debian
- **Ubuntu 18.04+** or **Debian-based** distribution
- **Desktop environment** (GNOME/Unity recommended)
- **Internet connection** for package downloads
- **sudo privileges** for package installation

### Fedora 🆕
- **Fedora 35+** (fully tested and optimized for Fedora 42)
- **Desktop environment** (GNOME recommended)
- **Internet connection** for package downloads
- **sudo privileges** for package installation
- **Modern styling** - Enhanced to match GNOME design language

## ⚡ Quick Installation

### Ubuntu/Debian - Terminal Setup

#### One-Line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/terminal-setup.sh | bash
```

#### Alternative: Download and Run
```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/terminal-setup.sh -o terminal-setup.sh

# Make executable and run
chmod +x terminal-setup.sh && ./terminal-setup.sh
```

#### Using wget
```bash
wget -qO- https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/terminal-setup.sh | bash
```

### Fedora - Terminal Setup 🆕

#### One-Line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fedora-terminal-setup.sh | bash
```

#### Alternative: Download and Run
```bash
# Download the Fedora script
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fedora-terminal-setup.sh -o fedora-terminal-setup.sh

# Make executable and run
chmod +x fedora-terminal-setup.sh && ./fedora-terminal-setup.sh
```

#### Using wget
```bash
wget -qO- https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fedora-terminal-setup.sh | bash
```

## ↩️ Easy Revert (Undo Terminal Setup)

Don't like the terminal setup? No problem! You can safely revert everything:

### Ubuntu/Debian Revert
```bash
# Revert all changes back to original state
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/terminal-setup.sh | bash -s -- --revert
```

### Fedora Revert 🆕
```bash
# Revert all changes back to original state
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fedora-terminal-setup.sh | bash -s -- --revert
```

### What Gets Reverted
- **Keyboard shortcut** - Ctrl+Alt+T opens default terminal again
- **Bash prompt** - Removes Git branch info, restores original prompt
- **Terminal shortcuts** - Removes enhanced word navigation and editing
- **Terminator config** - Restores original settings or removes custom config
- **All backups used** - Your original files are restored from automatic backups

### After Revert
- **Terminator stays installed** - But no longer configured or bound to Ctrl+Alt+T
- **Complete removal**: 
  - Ubuntu: `sudo apt remove terminator`
  - Fedora: `sudo dnf remove terminator`
- **Original experience** - Everything exactly as it was before running the terminal setup
- **Manual restart required**: Log out and back in to complete the revert process

**The revert is completely safe** and uses the same backup system that protects your files during installation!

## 🆕 Fedora-Specific Improvements

The Fedora version includes several enhancements over the original Ubuntu script:

### Fixed Dark Mode Issues
- **Visible pane dividers** - No more invisible splitters in dark system themes
- **Handle sizing** - 3px thick dividers that are always visible
- **Better contrast** - Inactive panes dimmed for clear focus indication

### Modern Ptyxis-Inspired Design 🎨
- **Borderless interface** - Clean, seamless integration with GNOME
- **Hidden tabs and title bars** - Minimal design matching Ptyxis aesthetic
- **Modern dark theme** - `#1a1a1a` background matching GNOME design language
- **Enhanced typography** - Optimized Monospace 11 font for better readability
- **Quiet operation** - All terminal bells disabled for professional use
- **Modern color palette** - Clean, high-contrast colors for better accessibility

### Fedora 42 Compatibility
- **Fixed keyboard shortcut logic** - Handles Fedora's different gsettings structure
- **Corrected command binding** - Ensures Terminator (not Ptyxis) opens with Ctrl+Alt+T
- **Better error handling** - Graceful handling of Fedora-specific configurations

### Ptyxis Integration
- **Native Fedora terminal** - Option to enhance Ptyxis instead of installing Terminator
- **Modern terminal** - Ptyxis is Fedora's new default terminal emulator
- **Consistent theming** - Works perfectly with Fedora's design language

## 🚀 Future Scripts (Coming Soon)

This repository will expand to include additional setup scripts for both Ubuntu and Fedora:

- **🌐 `networking-setup.sh`** - VPN, SSH keys, network tools
- **⚙️ `development-setup.sh`** - IDEs, compilers, development tools  
- **🎨 `desktop-setup.sh`** - Themes, extensions, desktop customization
- **🔒 `security-setup.sh`** - Firewall, security tools, hardening
- **📦 `apps-setup.sh`** - Essential applications and productivity tools

Each script will be focused, independent, and include the same revert functionality for both operating systems!

## 🛠️ Installation Steps

1. **Open default terminal** (Ctrl+Alt+T)
2. **Run the installation command** for your OS (see above)
3. **Wait for completion** (~1-2 minutes)
4. **Close terminal and press Ctrl+Alt+T** to open Terminator
5. **Enjoy your enhanced terminal experience!**

## ⚠️ Important Notes

### First-Time Setup
- **Run from default terminal** - Don't run from Terminator (it will restart)
- **Fresh terminal required** - Close all terminals after installation
- **Automatic backups** - Your existing configs are safely backed up

### Re-running the Script
- **Completely safe** - Script is idempotent and can be re-run anytime
- **Gets latest updates** - Re-running ensures you have the newest features
- **No duplicates** - Intelligently handles existing configurations

## 🎯 New Shortcuts After Installation

### Terminal Splitting
- **Ctrl + \\** - Split horizontally (top/bottom panes)
- **Ctrl + '** - Split vertically (side-by-side panes)
- **Mouse click** - Switch between panes

### Text Navigation
- **Ctrl + Left/Right** - Move cursor by word
- **Home/End** - Go to beginning/end of line
- **Fn + Home/End** - Alternative line navigation
- **Ctrl + A/E** - Classic terminal line navigation

### Text Editing
- **Ctrl + Backspace** - Delete word backward
- **Ctrl + Delete** - Delete word forward
- **Ctrl + U** - Clear entire line
- **Ctrl + K** - Clear from cursor to end of line

### Git Information
- **Automatic display** - Current branch shown in prompt
- **Visual indicators** - Colored prompt for easy reading
- **Repository status** - Shows "no git repo" when outside Git directories

## 🎨 Visual Changes

### Before (Default Terminal)
- Basic black terminal
- No Git information
- Standard keyboard shortcuts
- Single terminal window

### After (Enhanced Setup)
```
murage@computer:~/project [main]$ 
murage@computer:~/Documents [no git repo]$ 
```
- **Modern dark theme** with seamless GNOME integration
- **Borderless interface** - Clean, professional appearance
- **Git branch information** - Always visible in prompt
- **Enhanced keyboard shortcuts** - Modern text editing
- **Split-pane capability** - Multiple terminals in one window
- **🆕 Fedora**: Ptyxis-inspired design with visible pane dividers

## 🔧 Customization

### Terminator Configuration
Located at: `~/.config/terminator/config`

### Bash Prompt
Located at: `~/.bashrc` (Git prompt function)

### Keyboard Shortcuts
Located at: `~/.inputrc` (readline configuration)

### System Shortcuts
Managed by: `gsettings` (GNOME keyboard shortcuts)

## 🐛 Troubleshooting

### Script Won't Run

#### Ubuntu/Debian
```bash
# Check if you're on Ubuntu/Debian
lsb_release -a

# Ensure you have internet connection
ping -c 3 google.com

# Try running with explicit bash
bash <(curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/terminal-setup.sh)
```

#### Fedora 🆕
```bash
# Check if you're on Fedora
cat /etc/fedora-release

# Ensure you have internet connection
ping -c 3 google.com

# Try running with explicit bash
bash <(curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fedora-terminal-setup.sh)
```

### Don't Like the Setup?

#### Ubuntu/Debian
```bash
# Revert everything back to original state
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/terminal-setup.sh | bash -s -- --revert
```

#### Fedora 🆕
```bash
# Revert everything back to original state  
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fedora-terminal-setup.sh | bash -s -- --revert
```

### Shortcut Not Working
```bash
# Reload bash configuration
source ~/.bashrc

# Start a completely new terminal session
# Or restart your desktop environment
```

### Terminator Won't Open
```bash
# Check if Terminator installed correctly
which terminator

# Try opening manually
terminator

# Check keyboard shortcut configuration
gsettings list-recursively | grep terminal
```

### Git Prompt Not Showing
```bash
# Reload readline configuration
# Start a new terminal session

# Check if function exists
type git_branch
```

### Fedora-Specific Issues 🆕

#### Modern Styling Applied Successfully
```bash
# Verify the modern configuration was applied
cat ~/.config/terminator/config | grep -A 5 "\[global_config\]"

# Check if borderless design is active
cat ~/.config/terminator/config | grep "borderless"
```

#### Pane Dividers Still Not Visible
```bash
# Kill all Terminator processes and restart
pkill terminator
terminator

# Check if config applied correctly
cat ~/.config/terminator/config | grep handle_size
```

#### Keyboard Shortcut Issues
```bash
# Verify the correct keybinding was set
gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command

# Should return 'terminator' not 'ptyxis'
```

#### DNF Package Issues
```bash
# Update package cache
sudo dnf check-update

# Clear DNF cache
sudo dnf clean all

# Try installing Terminator manually
sudo dnf install -y terminator
```

## ⚡ Performance & Resource Usage

### No Performance Impact
This script is designed to be completely safe and lightweight:

- **No memory leaks** - All operations are one-time configurations
- **No background processes** - Script completes and exits cleanly
- **No CPU overhead** - No continuous monitoring or background services
- **Minimal resource usage** - Only adds ~5-10MB for Terminator GUI (normal for any terminal)

### What Actually Runs
| Component | Memory Impact | CPU Impact | Background Processes |
|-----------|---------------|------------|---------------------|
| Default Terminal | Baseline | Baseline | 0 |
| **After Script** | +~5-10MB (GUI only) | Negligible | 0 |
| Git prompt | <1KB per prompt | <0.1% when shown | 0 |
| Shortcuts | 0KB | 0% | 0 |

### Safe Components
- **Configuration files** - Read once at startup, zero runtime overhead
- **Git prompt function** - Only executes when displaying prompt (1-2 times per command)
- **Readline shortcuts** - Built into bash, highly optimized native features
- **System settings** - Standard GNOME configurations, no additional processes

**Your system performance remains exactly the same** - just with enhanced functionality! 🚀

## 🔄 Updating the Terminal Setup

To get the latest features and improvements for the terminal setup:

### Ubuntu/Debian
```bash
# Simply re-run the installation command
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/terminal-setup.sh | bash
```

### Fedora 🆕
```bash
# Simply re-run the installation command
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fedora-terminal-setup.sh | bash
```

The scripts intelligently update your terminal configuration while preserving your customizations.

## 📝 What Gets Backed Up

The scripts automatically create backups of:
- `~/.bashrc` → `~/.bashrc.backup.[timestamp]`
- `~/.inputrc` → `~/.inputrc.backup.[timestamp]`
- `~/.config/terminator/config` → `~/.config/terminator/config.backup.[timestamp]`
- **🆕 Fedora**: `~/.config/ptyxis-settings.backup` (if using Ptyxis enhancement)

## 🤝 Contributing

Feel free to submit issues and enhancement requests to the [GitHub repository](https://github.com/adrianmurage/New-Ubuntu-Setup).

### Adding New Operating System Support
We welcome contributions to support additional Linux distributions! Please follow the pattern established by the Ubuntu and Fedora scripts.

---

**Enjoy your enhanced Linux terminal experience on Ubuntu or Fedora!** 🎉

**🆕 Latest Fedora Updates:** The Fedora script now features modern Ptyxis-inspired styling, fixed keyboard shortcuts, and seamless GNOME integration. Your Terminator will look as clean and modern as Ptyxis while providing powerful split-pane functionality!
