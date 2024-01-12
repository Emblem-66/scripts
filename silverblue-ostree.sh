#!/bin/bash

#-----------------------------------------------------------------------------------------------#
#																								#
#	rpm-ostree cancel																			#
#	rpm-ostree rebase ostree-unverified-registry:ghcr.io/emblem-66/fedora-silverblue:latest		#
#																								#
#-----------------------------------------------------------------------------------------------#
#																								#
#					PERSONAL SCRIPT, DON'T USE IT ON YOUR PC UNLESS YOU ARE ME					#
#								"YOU ARE NOT YOU, YOU ARE ME. NO SHIT"							#
#																								#
#-----------------------------------------------------------------------------------------------#

sudo ostree admin pin 0

### Flatpak Setup

sudo flatpak override --reset
flatpak uninstall --all --delete-data --force-remove -y
sudo flatpak remote-modify --disable fedora
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify --enable flathub

### Auto mount

mkdir -p ~/HDD1 ~/HDD2 ~/HDD3 ~/SSD1 ~/SSD2
echo "LABEL=SSD1TB /var/home/pc/SSD1 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=HDD1TB /var/home/pc/HDD1 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=HDD2TB /var/home/pc/HDD2 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=HDD4TB /var/home/pc/HDD3 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=SSD1TB2 /var/home/pc/SSD2 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
sudo mount -a

### User folders

cat << EOF > ~/.config/user-dirs.dirs
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/HDD1/Documents"
XDG_MUSIC_DIR="$HOME/HDD1/Music"
XDG_PICTURES_DIR="$HOME/HDD1/Pictures"
XDG_VIDEOS_DIR="$HOME/HDD3/Videos"
EOF

rm -d Documents
rm -d Music
rm -d Pictures
rm -d Videos

### Bookmarks

cat << EOF > ~/.config/gtk-3.0/bookmarks
file:///var/home/pc/HDD1 HDD1
file:///var/home/pc/HDD2 HDD2
file:///var/home/pc/HDD3 HDD3
file:///var/home/pc/SSD1 SSD1
file:///var/home/pc/SSD2 SSD2
EOF

### Gsettings

gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.shell enabled-extensions "['gsconnect@andyholmes.github.io', 'caffeine@patapon.info']"

### Nautilus

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences default-sort-order 'type'
gsettings set org.gnome.nautilus.preferences default-sort-order 'name'
gsettings set org.gnome.nautilus.list-view use-tree-view true
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'type', 'date_modified']"

### Apple Fonts

# git clone https://github.com/aisgbnok/Apple-Fonts.git ~/.local/share/fonts/Apple-Fonts
# gsettings set org.gnome.desktop.interface font-name 'SF Pro Display 9' # 'System-ui 9'
# gsettings set org.gnome.desktop.interface monospace-font-name 'SF Mono 9' # 'Liberation Mono 9'
# gsettings set org.gnome.desktop.interface document-font-name 'New York 9' # 'System-ui 9'
# gsettings set org.gnome.desktop.wm.preferences titlebar-font 'SF Pro Display 9' # 'System-ui 9'

### Adw-gtk3 theme

flatpak install -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'

### MoreWaita Icons

git clone https://github.com/somepaulo/MoreWaita.git ~/.local/share/icons/MoreWaita
gsettings set org.gnome.desktop.interface icon-theme 'MoreWaita'

### Firefox gnome theme

flatpak install -y org.mozilla.firefox
flatpak run org.mozilla.firefox
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
find ~/.var/app/org.mozilla.firefox/.mozilla/firefox -type d -name "*default-release" -exec sh -c 'echo "#TabsToolbar {display: none;}" >> "{}/chrome/userChrome.css"' \;

### Gaming tools

flatpak install -y \
	com.vysp3r.ProtonPlus \
	com.github.Matoking.protontricks \
	org.freedesktop.Platform.VulkanLayer.gamescope \
	org.freedesktop.Platform.VulkanLayer.MangoHud \
	com.github.cubitect.cubiomes-viewer
flatpak override --user --env=MANGOHUD_CONFIG=no_display,position=middle-left,font_size=13,full,fps_limit=60


### Game Launchers

apps=(
"hu.kramo.Cartridges"
"com.usebottles.bottles"
"com.valvesoftware.Steam"
"com.heroicgameslauncher.hgl"
"org.openmw.OpenMW"
"org.prismlauncher.PrismLauncher"
"eu.vcmi.VCMI"
)

for app in "${apps[@]}"; do
	flatpak install -y "$app"
	flatpak override --user --env=MANGOHUD=1 "$app"
	flatpak override --user --filesystem=~/SSD1 "$app"
done

### Steam GNOME Theme

flatpak run com.valvesoftware.Steam
git clone https://github.com/tkashkin/Adwaita-for-Steam
cd Adwaita-for-Steam && ./install.py && cd ~ && rm -r -f Adwaita-for-Steam

### Flatpak apps install

flatpak_apps=(
app.drey.EarTag
app.drey.Warp
com.bitwarden.desktop
com.github.geigi.cozy
com.github.neithern.g4music
com.github.tchx84.Flatseal
com.github.unrud.VideoDownloader
com.mattjakeman.ExtensionManager
com.neatdecisions.Detwinner
com.transmissionbt.Transmission
eu.ithz.umftpd
fr.handbrake.ghb
io.github.cboxdoerfer.FSearch
io.github.celluloid_player.Celluloid
io.github.dvlv.boxbuddyrs
io.github.giantpinkrobots.varia
io.gitlab.adhami3310.Converter
io.gitlab.theevilskeleton.Upscaler
io.missioncenter.MissionCenter
net.mediaarea.MediaInfo
net.natesales.Aviator
org.filezillaproject.Filezilla
org.gnome.Calculator
org.gnome.Calendar
org.gnome.Chess
org.gnome.Evince
org.gnome.FileRoller
org.gnome.Loupe
org.gnome.SimpleScan
org.gnome.TextEditor
org.gnome.gThumb
org.gnome.gitlab.YaLTeR.Identity
org.gnome.meld
org.jdownloader.JDownloader
org.libreoffice.LibreOffice
org.nickvision.tubeconverter
org.onlyoffice.desktopeditors
)

for app in "${flatpak_apps[@]}"; do
    flatpak install -y $app
done
