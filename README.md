# Fresh Ubuntu Setup Script

A comprehensive script to set up a productive terminal environment on fresh Ubuntu installations. This script transforms your default terminal experience into a modern, efficient workspace with enhanced functionality.

## 🚀 What This Script Does

### Terminal Emulator Enhancement
- **Installs Terminator** - A powerful terminal emulator with splitting capabilities
- **Replaces Ctrl+Alt+T shortcut** - Opens Terminator instead of default terminal
- **Modern dark theme** - Clean interface with transparency and optimized colors
- **Enhanced splitting** - Easy pane management with intuitive shortcuts

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
- **No scrollbars/titlebars** - Clean, minimal interface
- **Intelligent tab completion** - Case-insensitive with colored results

## 📋 Requirements

- **Ubuntu 18.04+** or **Debian-based** distribution
- **Desktop environment** (GNOME/Unity recommended)
- **Internet connection** for package downloads
- **sudo privileges** for package installation

## ⚡ Quick Installation

### One-Line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fresh-install.sh | bash
```

### Alternative: Download and Run
```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fresh-install.sh -o fresh-install.sh

# Make executable and run
chmod +x fresh-install.sh && ./fresh-install.sh
```

### Using wget
```bash
wget -qO- https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fresh-install.sh | bash
```

## 🛠️ Installation Steps

1. **Open default terminal** (Ctrl+Alt+T)
2. **Run the installation command** (see above)
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
- Dark theme with transparency
- Git branch information
- Enhanced keyboard shortcuts
- Split-pane capability

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
```bash
# Check if you're on Ubuntu/Debian
lsb_release -a

# Ensure you have internet connection
ping -c 3 google.com

# Try running with explicit bash
bash <(curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fresh-install.sh)
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

## 🔄 Updating

To get the latest features and improvements:

```bash
# Simply re-run the installation command
curl -fsSL https://raw.githubusercontent.com/adrianmurage/New-Ubuntu-Setup/refs/heads/main/fresh-install.sh | bash
```

The script intelligently updates your configuration while preserving your customizations.

## 📝 What Gets Backed Up

The script automatically creates backups of:
- `~/.bashrc` → `~/.bashrc.backup.[timestamp]`
- `~/.inputrc` → `~/.inputrc.backup.[timestamp]`
- `~/.config/terminator/config` → `~/.config/terminator/config.backup.[timestamp]`

## 🤝 Contributing

Feel free to submit issues and enhancement requests to the [GitHub repository](https://github.com/adrianmurage/New-Ubuntu-Setup).

## 📄 License

This project is open source and available under standard open source terms.

---

**Enjoy your enhanced Ubuntu terminal experience!** 🎉
