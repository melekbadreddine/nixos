#!/usr/bin/env bash
# =============================================================
# install.sh — Portable installer for Mango WM dotfiles
# =============================================================
# Usage: bash install.sh
# =============================================================

set -euo pipefail

# ─── Colors ───
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Globals ───
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR=""
INSTALL_MODE=""
LINK_MODE=""
INSTALL_DEPS=""
PKG_MGR=""
PKG_INSTALL_CMD=""
PKG_CHECK_CMD=""

# ─── Helpers ──
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; }
header()  { echo -e "\n${BOLD}${CYAN}═══ $* ═══${NC}\n"; }

prompt() {
    local prompt_text="$1"
    local default="$2"
    local answer
    read -rp "$(echo -e "${YELLOW}${prompt_text}${NC} [${default}]: ")" answer
    echo "${answer:-$default}"
}

confirm() {
    local prompt_text="$1"
    local default="${2:-y}"
    local answer
    read -rp "$(echo -e "${YELLOW}${prompt_text}${NC} [${default}]: ")" answer
    answer="${answer:-$default}"
    [[ "$answer" =~ ^[Yy]$ ]]
}

# ─── Step 1: Distro Detection ───
detect_distro() {
    header "Detecting Distribution"

    if command -v dnf &>/dev/null; then
        PKG_MGR="dnf"
        PKG_INSTALL_CMD="sudo dnf install -y"
        PKG_CHECK_CMD="dnf list installed"
        info "Detected: Fedora/RHEL (dnf)"
    elif command -v apt &>/dev/null; then
        PKG_MGR="apt"
        PKG_INSTALL_CMD="sudo apt install -y"
        PKG_CHECK_CMD="dpkg -l"
        info "Detected: Debian/Ubuntu (apt)"
    elif command -v pacman &>/dev/null; then
        PKG_MGR="pacman"
        PKG_INSTALL_CMD="sudo pacman -S --noconfirm"
        PKG_CHECK_CMD="pacman -Q"
        info "Detected: Arch Linux (pacman)"
    elif command -v zypper &>/dev/null; then
        PKG_MGR="zypper"
        PKG_INSTALL_CMD="sudo zypper install -y"
        PKG_CHECK_CMD="zypper se --installed-only"
        info "Detected: openSUSE (zypper)"
    else
        warn "Could not detect package manager. Dependency installation will be skipped."
        PKG_MGR="unknown"
    fi
}

# ─── Step 2: Repo Location ───
get_repo_location() {
    header "Repository Location"
    echo "Where should the mango dotfiles repository live?"
    echo "This is where your config files will be stored."
    echo ""

    local default_repo="$SCRIPT_DIR"
    REPO_DIR="$(prompt "Repository path" "$default_repo")"

    # Expand ~ if present
    REPO_DIR="${REPO_DIR/#\~/$HOME}"

    info "Repository will be at: ${BOLD}$REPO_DIR${NC}"
}

# ─── Step 3: Install Mode ───
get_install_mode() {
    header "Install Mode"
    echo "What would you like to install?"
    echo ""
    echo "  [1] Full Mango WM setup"
    echo "      Window manager configs + waybar + themes + all tools"
    echo ""
    echo "  [2] Waybar-only"
    echo "      Status bar + theming system + screenshot + wallpaper picker"
    echo "      (No WM configs — use with your existing window manager)"
    echo ""

    local choice
    while true; do
        choice="$(prompt "Choose mode" "1")"
        case "$choice" in
            1) INSTALL_MODE="full"; break ;;
            2) INSTALL_MODE="waybar"; break ;;
            *) warn "Please enter 1 or 2" ;;
        esac
    done

    success "Mode: ${BOLD}$INSTALL_MODE${NC}"
}

# ─── Step 4: Symlink or Copy ───
get_link_mode() {
    header "Symlink or Copy"
    echo "How should config files be linked?"
    echo ""
    echo "  [1] Symlink (recommended)"
    echo "      Edit files in the repo, changes are reflected live"
    echo "      Repo must stay in place"
    echo ""
    echo "  [2] Copy"
    echo "      Standalone install, repo can be deleted after"
    echo "      Changes in repo won't affect installed configs"
    echo ""

    local choice
    while true; do
        choice="$(prompt "Choose method" "1")"
        case "$choice" in
            1) LINK_MODE="symlink"; break ;;
            2) LINK_MODE="copy"; break ;;
            *) warn "Please enter 1 or 2" ;;
        esac
    done

    success "Method: ${BOLD}$LINK_MODE${NC}"
}

# ─── Step 5: Dependencies ───
get_dep_mode() {
    header "Dependencies"
    echo "Should the installer handle package installation?"
    echo ""
    echo "  [1] Yes — auto-install required packages + themes + icons"
    echo "  [2] No — just print a checklist for manual install"
    echo ""

    local choice
    while true; do
        choice="$(prompt "Install dependencies" "1")"
        case "$choice" in
            1) INSTALL_DEPS="yes"; break ;;
            2) INSTALL_DEPS="no"; break ;;
            *) warn "Please enter 1 or 2" ;;
        esac
    done

    success "Dependencies: ${BOLD}$INSTALL_DEPS${NC}"
}

# ─── Step 6: Backup Existing Configs ───
backup_configs() {
    header "Backing Up Existing Configs"

    local timestamp
    timestamp="$(date +%Y%m%d_%H%M%S)"

    for target in waybar wofi mango; do
        local src="$HOME/.config/$target"
        local backup="$HOME/.config/${target}.bak.${timestamp}"
        if [ -e "$src" ]; then
            info "Backing up ~/.config/$target → $backup"
            cp -a "$src" "$backup"
            success "Backed up $target"
        else
            info "No existing ~/.config/$target found — skipping backup"
        fi
    done
}

# ─── Dependency Helpers ───
pkg_installed() {
    local pkg="$1"
    case "$PKG_MGR" in
        dnf)    dnf list installed "$pkg" &>/dev/null ;;
        apt)    dpkg -l "$pkg" 2>/dev/null | grep -q "^ii" ;;
        pacman) pacman -Q "$pkg" &>/dev/null ;;
        zypper) zypper se --installed-only "$pkg" &>/dev/null ;;
        *)      return 1 ;;
    esac
}

install_repo_pkg() {
    local pkg="$1"
    if pkg_installed "$pkg"; then
        info "Already installed: $pkg"
        return 0
    fi
    info "Installing: $pkg"
    if $PKG_INSTALL_CMD "$pkg" 2>/dev/null; then
        success "Installed: $pkg"
        return 0
    else
        warn "Failed to install: $pkg"
        return 1
    fi
}

install_github_theme() {
    local name="$1"
    local url="$2"
    local target_dir="${3:-$HOME/.local/share/themes}"
    local tmpdir
    tmpdir="$(mktemp -d)"

    info "Downloading $name from GitHub..."
    if command -v git &>/dev/null; then
        git clone --depth=1 "$url" "$tmpdir/$name" 2>/dev/null || {
            warn "Failed to clone $name"
            rm -rf "$tmpdir"
            return 1
        }
    elif command -v curl &>/dev/null; then
        curl -sL "$url/archive/main.tar.gz" -o "$tmpdir/$name.tar.gz" || {
            warn "Failed to download $name"
            rm -rf "$tmpdir"
            return 1
        }
        tar -xzf "$tmpdir/$name.tar.gz" -C "$tmpdir" || {
            warn "Failed to extract $name"
            rm -rf "$tmpdir"
            return 1
        }
        mv "$tmpdir"/* "$tmpdir/$name" 2>/dev/null || true
    else
        warn "Need git or curl to download $name"
        rm -rf "$tmpdir"
        return 1
    fi

    mkdir -p "$target_dir"
    # Find the actual theme directory (could be top-level or nested)
    local src_dir="$tmpdir/$name"
    if [ -d "$tmpdir"/*/ ] && [ ! -f "$tmpdir/$name/index.theme" ]; then
        src_dir="$(echo "$tmpdir"/*/ | head -1)"
    fi
    cp -r "$src_dir" "$target_dir/"
    rm -rf "$tmpdir"
    success "Installed: $name → $target_dir/"
}

install_github_icon_theme() {
    local name="$1"
    local url="$2"
    local target_dir="$HOME/.local/share/icons"
    local tmpdir
    tmpdir="$(mktemp -d)"

    info "Downloading $name from GitHub..."
    if command -v git &>/dev/null; then
        git clone --depth=1 "$url" "$tmpdir/$name" 2>/dev/null || {
            warn "Failed to clone $name"
            rm -rf "$tmpdir"
            return 1
        }
    elif command -v curl &>/dev/null; then
        curl -sL "$url/archive/main.tar.gz" -o "$tmpdir/$name.tar.gz" || {
            warn "Failed to download $name"
            rm -rf "$tmpdir"
            return 1
        }
        tar -xzf "$tmpdir/$name.tar.gz" -C "$tmpdir" || {
            warn "Failed to extract $name"
            rm -rf "$tmpdir"
            return 1
        }
        mv "$tmpdir"/* "$tmpdir/$name" 2>/dev/null || true
    else
        warn "Need git or curl to download $name"
        rm -rf "$tmpdir"
        return 1
    fi

    mkdir -p "$target_dir"
    local src_dir="$tmpdir/$name"
    if [ -d "$tmpdir"/*/ ] && [ ! -f "$tmpdir/$name/index.theme" ]; then
        src_dir="$(echo "$tmpdir"/*/ | head -1)"
    fi
    cp -r "$src_dir" "$target_dir/"
    rm -rf "$tmpdir"

    # Update icon cache
    if command -v gtk-update-icon-cache &>/dev/null; then
        gtk-update-icon-cache -f -t "$target_dir/$name" 2>/dev/null || true
    fi
    success "Installed: $name → $target_dir/"
}

# ─── Step 5a: Install Dependencies ───
install_dependencies() {
    if [ "$INSTALL_DEPS" != "yes" ]; then
        return
    fi

    header "Installing Dependencies"

    # ─── Required packages ───
    local required_pkgs=(
        "waybar" "kitty" "wofi" "mako"
        "grim" "slurp" "wl-clipboard"
        "ImageMagick" "jq" "libnotify"
    )

    # Distro-specific package names
    local python_gobject="python3-gobject"
    local python_evdev="python3-evdev"
    local gtk3="gtk3"
    local gtk4="gtk4"
    local qt5="qt5-qtbase"
    local qt6="qt6-qtbase"

    case "$PKG_MGR" in
        dnf)
            python_gobject="python3-gobject"
            python_evdev="python3-evdev"
            gtk3="gtk3"
            gtk4="gtk4"
            qt5="qt5-qtbase"
            qt6="qt6-qtbase"
            ;;
        apt)
            python_gobject="python3-gi"
            python_evdev="python3-evdev"
            gtk3="libgtk-3-0"
            gtk4="libgtk-4-1"
            qt5="qtbase5-dev"
            qt6="qt6-base-dev"
            ;;
        pacman)
            python_gobject="python-gobject"
            python_evdev="python-evdev"
            gtk3="gtk3"
            gtk4="gtk4"
            qt5="qt5-base"
            qt6="qt6-base"
            ;;
        zypper)
            python_gobject="python3-gobject"
            python_evdev="python3-evdev"
            gtk3="gtk3"
            gtk4="gtk4"
            qt5="libqt5-qtbase"
            qt6="libqt6-qtbase"
            ;;
    esac

    required_pkgs+=("$python_gobject" "$python_evdev" "$gtk3" "$gtk4" "$qt5" "$qt6")

    info "Installing required packages..."
    for pkg in "${required_pkgs[@]}"; do
        install_repo_pkg "$pkg" || true
    done

    # ─── GTK Themes ───
    header "Installing GTK Themes"

    # Graphite
    if ! pkg_installed "graphite-gtk-theme" 2>/dev/null; then
        install_github_theme "graphite-gtk-theme" \
            "https://github.com/vinceliuice/graphite-gtk-theme" \
            "$HOME/.local/share/themes" || true
    else
        install_repo_pkg "graphite-gtk-theme" || true
    fi

    # Catppuccin
    if ! pkg_installed "catppuccin-gtk-theme-mocha" 2>/dev/null; then
        install_github_theme "catppuccin-gtk-theme" \
            "https://github.com/catppuccin/gtk" \
            "$HOME/.local/share/themes" || true
    else
        install_repo_pkg "catppuccin-gtk-theme-mocha" || true
    fi

    # Material-Black (GitHub only)
    install_github_theme "Material-Black" \
        "https://github.com/Elbullazul/Material-Black" \
        "$HOME/.local/share/themes" || true

    # ─── Icon Themes ───
    header "Installing Icon Themes"

    # Tela
    if ! pkg_installed "tela-icon-theme" 2>/dev/null; then
        install_github_icon_theme "Tela-icon-theme" \
            "https://github.com/vinceliuice/Tela-icon-theme" || true
    else
        install_repo_pkg "tela-icon-theme" || true
    fi

    # Gruvbox-Plus (GitHub only)
    install_github_icon_theme "gruvbox-plus-icon-pack" \
        "https://github.com/SylEleuth/gruvbox-plus-icon-pack" || true

    # ─── Cursor Theme ───
    header "Installing Cursor Theme"

    if ! pkg_installed "bibata-cursor-theme" 2>/dev/null; then
        install_github_icon_theme "Bibata_Cursor" \
            "https://github.com/ful1e5/Bibata_Cursor" || true
    else
        install_repo_pkg "bibata-cursor-theme" || true
    fi

    success "Dependency installation complete!"
}

# ─── Link/Copy Helper ───
link_or_copy() {
    local src="$1"
    local dest="$2"

    if [ "$LINK_MODE" = "symlink" ]; then
        # Remove existing file/dir
        rm -rf "$dest"
        ln -sf "$src" "$dest"
        info "Symlinked: $dest → $src"
    else
        rm -rf "$dest"
        cp -a "$src" "$dest"
        info "Copied: $dest"
    fi
}

# ─── Step 7: Execute Install ───
execute_install() {
    header "Installing Mango Dotfiles"

    info "Repository: $REPO_DIR"
    info "Mode: $INSTALL_MODE"
    info "Method: $LINK_MODE"
    echo ""

    # Create target directories
    mkdir -p "$HOME/.config/mango"

    if [ "$INSTALL_MODE" = "full" ]; then
        # ─── Full Mode ───
        info "Installing full Mango WM setup..."

        # Core config files
        link_or_copy "$REPO_DIR/bind.conf"        "$HOME/.config/mango/bind.conf"
        link_or_copy "$REPO_DIR/config.conf"       "$HOME/.config/mango/config.conf"
        link_or_copy "$REPO_DIR/env.conf"          "$HOME/.config/mango/env.conf"
        link_or_copy "$REPO_DIR/autostart.sh"      "$HOME/.config/mango/autostart.sh"
        link_or_copy "$REPO_DIR/.theme"            "$HOME/.config/mango/.theme"
        link_or_copy "$REPO_DIR/.recording_mode"   "$HOME/.config/mango/.recording_mode"

        # Hardware-neutral defaults
        link_or_copy "$REPO_DIR/monitor.conf.default" "$HOME/.config/mango/monitor.conf"
        link_or_copy "$REPO_DIR/tag.conf.default"     "$HOME/.config/mango/tag.conf"
        link_or_copy "$REPO_DIR/rule.conf.default"    "$HOME/.config/mango/rule.conf"

        # Directories
        link_or_copy "$REPO_DIR/bin"         "$HOME/.config/mango/bin"
        link_or_copy "$REPO_DIR/templates"   "$HOME/.config/mango/templates"
        link_or_copy "$REPO_DIR/themes"      "$HOME/.config/mango/themes"
        link_or_copy "$REPO_DIR/bars"        "$HOME/.config/mango/bars"

        # Waybar and Wofi (separate symlinks)
        link_or_copy "$REPO_DIR/waybar"      "$HOME/.config/waybar"
        link_or_copy "$REPO_DIR/wofi"        "$HOME/.config/wofi"

    else
        # ─── Waybar-Only Mode ───
        info "Installing Waybar-only setup..."

        # Create minimal mango directory structure
        mkdir -p "$HOME/.config/mango/bin"
        mkdir -p "$HOME/.config/mango/templates"
        mkdir -p "$HOME/.config/mango/themes"
        mkdir -p "$HOME/.config/mango/bars"

        # Core files needed for theming
        link_or_copy "$REPO_DIR/.theme"            "$HOME/.config/mango/.theme"
        link_or_copy "$REPO_DIR/bars"              "$HOME/.config/mango/bars"
        link_or_copy "$REPO_DIR/templates"         "$HOME/.config/mango/templates"
        link_or_copy "$REPO_DIR/themes"            "$HOME/.config/mango/themes"

        # Specific bin scripts
        link_or_copy "$REPO_DIR/bin/generate-waybar-config.py" "$HOME/.config/mango/bin/generate-waybar-config.py"
        link_or_copy "$REPO_DIR/bin/switch-theme.sh"           "$HOME/.config/mango/bin/switch-theme.sh"
        link_or_copy "$REPO_DIR/bin/screenshot.sh"             "$HOME/.config/mango/bin/screenshot.sh"
        link_or_copy "$REPO_DIR/bin/wall-select.py"            "$HOME/.config/mango/bin/wall-select.py"
        link_or_copy "$REPO_DIR/bin/wall-select.sh"            "$HOME/.config/mango/bin/wall-select.sh"

        # Waybar and Wofi
        link_or_copy "$REPO_DIR/waybar"      "$HOME/.config/waybar"
        link_or_copy "$REPO_DIR/wofi"        "$HOME/.config/wofi"
    fi

    # Make scripts executable
    chmod +x "$HOME/.config/mango/bin/"*.sh 2>/dev/null || true
    chmod +x "$HOME/.config/mango/bin/"*.py 2>/dev/null || true
    chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true
    chmod +x "$HOME/.config/waybar/scripts/"*.py 2>/dev/null || true

    success "Files installed!"
}

# ─── Step 8: Post-Install ───
post_install() {
    header "Post-Install Setup"

    # Run switch-theme.sh --apply to generate initial configs
    if [ -f "$HOME/.config/mango/bin/switch-theme.sh" ]; then
        info "Generating initial configs..."
        bash "$HOME/.config/mango/bin/switch-theme.sh" --apply 2>/dev/null || {
            warn "switch-theme.sh --apply failed (this is OK on first run)"
        }
        success "Initial configs generated"
    fi

    # Print keybind reference
    print_keybinds

    # Print dependency checklist if not installed
    if [ "$INSTALL_DEPS" != "yes" ]; then
        print_dep_checklist
    fi

    # Print optional apps checklist
    print_optional_apps

    header "Installation Complete!"
    echo "Your mango dotfiles are installed at: ${BOLD}$REPO_DIR${NC}"
    echo ""
    if [ "$LINK_MODE" = "symlink" ]; then
        echo "Configs are symlinked. Edit files in the repo to see changes live."
    else
        echo "Configs are copied. The repo can be safely deleted."
    fi
    echo ""
    echo "To apply the current theme:"
    echo "  ${CYAN}~/.config/mango/bin/switch-theme.sh${NC}"
    echo ""
    echo "To reload config:"
    echo "  ${CYAN}SUPER+ALT+R${NC}"
    echo ""
}

# ─── Keybind Reference ───
print_keybinds() {
    header "Keybind Reference"
    cat << 'KEYBINDS'
┌─────────────────────────────────────────────────────────────┐
│  Mango WM — Keybind Reference                               │
├─────────────────────────────────────────────────────────────┤
│  SYSTEM                                                     │
│  SUPER+ALT+R    Reload config                               │
│  SUPER+ALT+L    Lock screen                                 │
│  SUPER+M        Quit Mango                                  │
│  SUPER+Q        Kill focused window                         │
│  SUPER+SHIFT+Q  Logout menu (wlogout)                       │
│  SUPER+SHIFT+T  Theme picker                                │
│  SUPER+SHIFT+W  Wallpaper picker                            │
│                                                             │
│  APPS                                                       │
│  SUPER+Return   Terminal (kitty)                            │
│  SUPER+Space    App launcher (wofi)                         │
│  SUPER+S        Steam                                       │
│  SUPER+O        OBS                                         │
│  SUPER+Z        Zed editor                                  │
│  SUPER+E        Helix (in kitty)                            │
│  SUPER+Y        Yazi file manager (floating)                │
│  SUPER+D        Discord                                     │
│  SUPER+G        Telegram                                    │
│  SUPER+B        Helium browser                              │
│  SUPER+ALT+B    Qutebrowser                                 │
│  SUPER+K        Kdenlive                                    │
│  SUPER+F        Nemo file manager                           │
│                                                             │
│  WINDOW FOCUS (SUPER + Arrows)                              │
│  SUPER+Left/Right/Up/Down    Focus direction                │
│  SUPER+SHIFT+Arrows          Move window direction          │
│                                                             │
│  WORKSPACES                                                 │
│  SUPER+1-9               View workspace 1-9                 │
│  SUPER+SHIFT+1-9         Move window to workspace           │
│  SUPER+CTRL+Up/Down      Switch workspace left/right        │
│  SUPER+CTRL+ALT+Up/Down  Move window to workspace           │
│                                                             │
│  WINDOW STATES                                              │
│  SUPER+W       Toggle floating                              │
│  ALT+Tab       Toggle overview                              │
│  SUPER+Tab     Focus stack next                             │
│  SUPER+X       Logout menu                                  │
│  ALT+F         Toggle fullscreen                            │
│  ALT+SHIFT+F   Toggle fake fullscreen                       │
│  ALT+A         Toggle maximize                              │
│  SUPER+I       Minimize                                     │
│  SUPER+SHIFT+I Restore minimized                            │
│  ALT+Z         Toggle scratchpad                            │
│                                                             │
│  SCREENSHOT                                                 │
│  SUPER+SHIFT+S  Area screenshot (grim+slurp)                │
│                                                             │
│  GAPS & LAYOUT                                              │
│  CTRL+Space     Switch layout                               │
│  ALT+SHIFT+X/Z  Increase/decrease gaps                      │
│  ALT+SHIFT+R    Toggle gaps                                 │
│                                                             │
│  MOUSE                                                      │
│  SUPER+LeftBtn   Move window                                │
│  SUPER+RightBtn  Resize window                              │
└─────────────────────────────────────────────────────────────┘
KEYBINDS
}

# ─── Dependency Checklist ───
print_dep_checklist() {
    header "Required Dependencies (Install Manually)"
    cat << 'DEPS'
┌─────────────────────────────────────────────────────────────┐
│  Required Packages                                          │
├─────────────────────────────────────────────────────────────┤
│  waybar          Status bar                                 │
│  kitty           Terminal emulator                          │
│  wofi            Application launcher                       │
│  mako            Notification daemon                        │
│  grim            Screenshot capture                         │
│  slurp           Area selection                             │
│  wl-clipboard    Clipboard support                          │
│  ImageMagick     Image processing (logo theming)            │
│  jq              JSON processor                             │
│  libnotify       Desktop notifications                      │
│  python3-gobject GTK Python bindings                        │
│  python3-evdev   Input device access                        │
│  gtk3 / gtk4     GTK libraries                              │
│  qt5-qtbase      Qt5 libraries                              │
│  qt6-qtbase      Qt6 libraries                              │
└─────────────────────────────────────────────────────────────┘
DEPS
}

# ─── Optional Apps Checklist ───
print_optional_apps() {
    header "Optional Apps (Launched via Keybinds)"
    cat << 'OPTIONAL'
┌─────────────────────────────────────────────────────────────┐
│  Optional Applications                                      │
├─────────────────────────────────────────────────────────────┤
│  steam           Steam gaming platform                      │
│  obs             OBS Studio (streaming/recording)           │
│  zed             Zed editor                                 │
│  helix           Helix editor (hx)                          │
│  yazi            Terminal file manager                      │
│  discord         Discord                                    │
│  telegram        Telegram desktop                           │
│  qutebrowser     Keyboard-driven browser                    │
│  kdenlive        Video editor                               │
│  nemo            File manager                               │
│  crystal-dock    Desktop dock                               │
│  awww            Wallpaper daemon                           │
│  wlogout         Logout menu                                │
│  fzf             Fuzzy finder                               │
│  fastfetch       System info display                        │
│  htop            Process monitor                            │
└─────────────────────────────────────────────────────────────┘
OPTIONAL
}

# ─── Main ──
main() {
    echo ""
    echo -e "${BOLD}${CYAN}"
    cat << 'BANNER'
 ╔══════════════════════════════════════════════════════════╗
 ║                                                          ║
 ║    ███╗   ███╗ █████╗ ███╗   ██╗██╗ ██████╗             ║
 ║    ████╗ ████║██╔══██╗████╗  ██║██║██╔════╝             ║
 ║    ██╔████╔██║███████║██╔██╗ ██║██║██║  ███╗            ║
 ║    ██║╚██╔╝██║██╔══██║██║╚██╗██║██║██║   ██║            ║
 ║    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║╚██████╔╝            
 ║    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝             ║
 ║                                                          ║
 ║              Mango WM Dotfiles Installer                  ║
 ║                                                          ║
 ╚══════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"

    detect_distro
    get_repo_location
    get_install_mode
    get_link_mode
    get_dep_mode

    echo ""
    info "Summary:"
    echo "  Repo:     $REPO_DIR"
    echo "  Mode:     $INSTALL_MODE"
    echo "  Method:   $LINK_MODE"
    echo "  Deps:     $INSTALL_DEPS"
    echo ""

    if ! confirm "Proceed with installation?"; then
        info "Installation cancelled."
        exit 0
    fi

    backup_configs
    install_dependencies
    execute_install
    post_install
}

main "$@"
