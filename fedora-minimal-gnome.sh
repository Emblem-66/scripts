#!/bin/bash

#
#
#
#
#


# This is a script that will install a minimal GNOME on a minimal Fedora Everything install
# This script was made for Fedora 38
# 1. Get the Fedora Everything ISO: https://alt.fedoraproject.org/
# 2. When installing select "Minimal install" where you select software.

# Install curl to download and run this script trough that, or just copy paste the lines

# Let's make dnf a little bit faster first
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
sudo dnf update

# You could even go more minimal GNOME than this, but why would you want to?
sudo dnf install gnome-shell gnome-console nautilus gnome-text-editor xdg-user-dirs xdg-user-dirs-gtk flatpak bash-completion tar bzip2 -y

# Add the flatpak repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable gdm
sudo systemctl enable gdm
sudo systemctl set-default graphical.target

# Then all you have to do is to install any extra packages or drivers that you need and reboot
# Note that flatpak will need a reboot before you install any apps from flathub
# If you run this script in a VM you may want to install the kernel-devel package as well


#
#
#
#
#

sudo flatpak override --reset
sudo flatpak uninstall --all --delete-data --force-remove -y
sudo flatpak remote-modify --disable fedora
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify --enable flathub

sudo dnf install -y \
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y copr enable cboxdoerfer/fsearch
sudo dnf -y copr enable petersen/ptyxis 
sudo dnf -y copr enable atim/heroic-games-launcher
sudo dnf -y copr enable wehagy/protonplus

sudo dnf install -y \
adw-gtk3-theme \
fsearch \
ffmpegthumbnailer \
steam \
bottles \
heroic-games-launcher-bin \
protonplus \
goverlay \
gthumb \
ptyxis \
distrobox \
ibm-plex-fonts-all \
adobe-source-serif-pro-fonts \
adobe-source-sans-pro-fonts \
rsms-inter-fonts \
cascadia-code-fonts \
gnome-shell-extension-caffeine \
gnome-shell-extension-dash-to-dock \
virt-manager \
piper

flatpak install -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.shell enabled-extensions ['caffeine@patapon.info', 'legacyschemeautoswitcher@joshimukul29.gmail.com']
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences default-sort-order 'type'
gsettings set org.gnome.nautilus.preferences default-sort-order 'name'
gsettings set org.gnome.nautilus.list-view use-tree-view true
gsettings set org.gnome.nautilus.list-view default-visible-columns ['name', 'size', 'type', 'date_modified']
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'

#flatpak install -y org.mozilla.firefox
#flatpak run org.mozilla.firefox
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
#find ~/.var/app/org.mozilla.firefox/.mozilla/firefox -type d -name *default-release -exec sh -c 'echo #TabsToolbar {display: none;} >> {}/chrome/userChrome.css' \;
find ~/.mozilla/firefox -type d -name *default-release -exec sh -c 'echo #TabsToolbar {display: none;} >> {}/chrome/userChrome.css' \;

#flatpak install -y \
#com.vysp3r.ProtonPlus com.github.Matoking.protontricks \
#org.freedesktop.Platform.VulkanLayer.MangoHud \
#com.usebottles.bottles \
#com.valvesoftware.Steam \
#com.heroicgameslauncher.hgl
#flatpak override --user --env=MANGOHUD_CONFIG=no_display,position=middle-left,font_size=13,full,fps_limit=60
#flatpak override --user --env=MANGOHUD=1 com.usebottles.bottles
#flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam
#flatpak override --user --env=MANGOHUD=1 com.heroicgameslauncher.hgl

flatpak install -y \
com.bitwarden.desktop \
com.discordapp.Discord \
com.github.geigi.cozy \
com.github.neithern.g4music \
com.github.tchx84.Flatseal \
com.mattjakeman.ExtensionManager \
io.github.celluloid_player.Celluloid \
net.mediaarea.MediaInfo \
org.jdownloader.JDownloader \
org.onlyoffice.desktopeditors

com.bitwarden.desktop
com.discordapp.Discord
com.github.Matoking.protontricks
com.github.geigi.cozy
com.github.neithern.g4music
com.github.rafostar.Clapper
com.github.tchx84.Flatseal
com.heroicgameslauncher.hgl
com.mattjakeman.ExtensionManager
com.spotify.Client
com.usebottles.bottles
com.valvesoftware.Steam
com.vysp3r.ProtonPlus
de.haeckerfelix.Fragments
io.github.celluloid_player.Celluloid
io.github.dvlv.boxbuddyrs
io.github.flattool.Warehouse
net.mediaarea.MediaInfo
org.gnome.Loupe
org.gnome.Papers
org.gnome.Showtime
org.gnome.TextEditor
org.jdownloader.JDownloader
org.localsend.localsend_app
org.mozilla.firefox
org.onlyoffice.desktopeditors
org.prismlauncher.PrismLauncher



git clone https://github.com/mukul29/legacy-theme-auto-switcher-gnome-extension.git /usr/share/gnome-shell/extensions/legacyschemeautoswitcher@joshimukul29.gmail.com

sudo dnf uninstall -y \
toolbox \
yelp \
yelp-xsl \
yelp-libs \
gnome-tour \
noopenh264 \
ffmpeg-free \
gnome-terminal \
gnome-terminal-nautilus \
