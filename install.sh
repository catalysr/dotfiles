#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Starting Arch Linux Package Reinstallation ==="

# 1. System Base & Boot
BASE_PKGS=(
    base linux linux-headers linux-firmware intel-ucode
    sof-firmware grub efibootmgr os-prober sudo
)

# 2. Graphics & Video (Nvidia Open Drivers)
GRAPHICS_PKGS=(
    nvidia-open nvidia-utils libva-nvidia-driver egl-wayland
)

# 3. Networking & Bluetooth
NETWORK_PKGS=(
    networkmanager network-manager-applet ufw bluez bluez-utils
)

# 4. Display Manager & Wayland Compositor (Hyprland ecosystem)
HYPR_PKGS=(
    hyprland uwsm hypridle hyprlock hyprpaper hyprpicker 
    hyprpolkitagent hyprsunset hyprlauncher waybar swaync
)

# 5. Audio Server (Pipewire)
AUDIO_PKGS=(
    pipewire pipewire-alsa pipewire-jack pipewire-pulse 
    wireplumber gst-plugin-pipewire libpulse pavucontrol
)

# 6. Terminals, Shells & CLI Utilities (Wezterm and Kitty removed, Foot remains)
CLI_PKGS=(
    foot zsh tmux btop fastfetch fzf ripgrep 
    zoxide git make clang tree-sitter-cli lua-language-server
    brightnessctl libnewt python-pip python-pillow python-gobject 
    python-platformdirs
)

# 7. File Management & Archiving
FILE_PKGS=(
    thunar thunar-archive-plugin file-roller gvfs unrar xdg-user-dirs
)

# 8. Fonts
FONT_PKGS=(
    noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu 
    ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-liberation 
    ttf-nerd-fonts-symbols woff2-font-awesome
)

# 9. Themes & Customization
THEME_PKGS=(
    nwg-look adw-gtk-theme materia-gtk-theme orchis-theme gnome-themes-extra
)

# 10. Applications & Daily Tools
APP_PKGS=(
    firefox discord spotify-launcher steam qbittorrent flatpak
    bemenu bemenu-wayland grim slurp satty flameshot 
    xdg-desktop-portal-hyprland zram-generator power-profiles-daemon stow
)

# Combine all package arrays
ALL_PACKAGES=(
    "${BASE_PKGS[@]}"
    "${GRAPHICS_PKGS[@]}"
    "${NETWORK_PKGS[@]}"
    "${HYPR_PKGS[@]}"
    "${AUDIO_PKGS[@]}"
    "${CLI_PKGS[@]}"
    "${FILE_PKGS[@]}"
    "${FONT_PKGS[@]}"
    "${THEME_PKGS[@]}"
    "${APP_PKGS[@]}"
)

echo "--> Updating system databases..."
sudo pacman -Sy

echo "--> Installing all categorized packages..."
sudo pacman -S --needed "${ALL_PACKAGES[@]}"

echo "--> Enabling essential system services..."
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable ufw.service
sudo systemctl enable power-profiles-daemon.service

echo "=== Installation Complete! Please reboot your system. ==="

