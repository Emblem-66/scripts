#!/bin/bash

# Function to perform task 1
perform_task1() {
    echo "Performing task 1..."
    # Add commands for task 1
}

# Function to perform task 2
perform_task2() {
    echo "Performing task 2..."
    # Add commands for task 2
}

echo "Welcome to the setup script!"

# Prompt user for input (accept only "y" or "n")
read -p "Do you want to perform task 1? (y/n): " task1
read -p "Do you want to perform task 2? (y/n): " task2

# Convert input to lowercase for case-insensitivity
task1="${task1,,}"
task2="${task2,,}"

# Validate input
if [[ "$task1" != "y" && "$task1" != "n" ]]; then
    echo "Invalid input for task 1. Please enter 'y' or 'n'."
    exit 1
fi

if [[ "$task2" != "y" && "$task2" != "n" ]]; then
    echo "Invalid input for task 2. Please enter 'y' or 'n'."
    exit 1
fi

# Perform tasks based on user input
if [ "$task1" == "y" ]; then
    perform_task1
fi

if [ "$task2" == "y" ]; then
    perform_task2
fi

echo "Setup script completed."


#--------

echo "Welcome to the setup script!"

# Prompt user for input
read -p "Perform task 1? (yes/no): " task1

# Perform tasks based on user input
if [ "$task1" == "yes" ]; then
    echo "Performing task 1..."
    # Add commands for task 1
fi

#--------

echo "Welcome to the setup script!"

# Prompt user for input (accept only "y" or "n")
read -p "Do you want to perform task 1? (y/n): " task1

# Convert input to lowercase for case-insensitivity
task1="${task1,,}"

# Validate input
if [[ "$task1" != "y" && "$task1" != "n" ]]; then
    echo "Invalid input for task 1. Please enter 'y' or 'n'."
    exit 1
fi

# Perform tasks based on user input
if [ "$task1" == "y" ]; then
    echo "Performing task 1..."
    # Add commands for task 1
fi

echo "Setup script completed."

#--------


### rebase
gnome-terminal --command "rpm-ostree cancel && rpm-ostree rebase" &

#	rpm-ostree cancel
#	rpm-ostree rebase ostree-unverified-registry:ghcr.io/emblem-66/fedora-silverblue:latest

sudo ostree admin pin 0

### Flatpak Setup

sudo flatpak override --reset
flatpak uninstall --all --delete-data --force-remove -y
sudo flatpak remote-modify --disable fedora
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify --enable flathub

### Auto mount

mkdir -p ~/HDD1 ~/HDD2 ~/HDD3 ~/SSD1 ~/SSD2
echo "LABEL=HDD1TB /var/home/pc/HDD1 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=HDD2TB /var/home/pc/HDD2 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=HDD4TB /var/home/pc/HDD3 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=SSD1TB /var/home/pc/SSD1 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
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

### .bashrc

cat << EOF > ~/.bashrc
update() {
rpm-ostree upgrade; flatpak update -y; flatpak uninstall --unused -y
}
EOF

### scripts

### Gsettings

gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.shell enabled-extensions "['caffeine@patapon.info']"

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

gsettings set org.gnome.desktop.interface font-name 'System-ui 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'Liberation Mono 12'
gsettings set org.gnome.desktop.interface document-font-name 'System-ui 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'System-ui 10'

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
	# flatpak override --user --filesystem=~/SSD1 "$app"
done

### Steam GNOME Theme

flatpak run com.valvesoftware.Steam
git clone https://github.com/tkashkin/Adwaita-for-Steam
cd Adwaita-for-Steam && ./install.py && cd ~ && rm -r -f Adwaita-for-Steam

### Flatpak apps install

echo "base apps"
flatpak install \
app.drey.Warp \
com.bitwarden.desktop \
com.github.geigi.cozy \
com.github.neithern.g4music \
com.github.tchx84.Flatseal \
com.mattjakeman.ExtensionManager
com.neatdecisions.Detwinner \
io.github.cboxdoerfer.FSearch \
org.gnome.Evince \
org.gnome.FileRoller \
org.gnome.Loupe \
org.gnome.Calculator \
io.github.celluloid_player.Celluloid \
io.github.dvlv.boxbuddyrs \
io.missioncenter.MissionCenter \
org.gnome.Calendar \
org.gnome.Chess \
org.gnome.TextEditor \
org.gnome.gThumb

echo "office"
flatpak install \
org.libreoffice.LibreOffice \
org.onlyoffice.desktopeditors \
org.gnome.meld \
org.gnome.SimpleScan

echo "media tools"
flatpak install \
app.drey.EarTag
fr.handbrake.ghb
net.mediaarea.MediaInfo
net.natesales.Aviator
io.gitlab.adhami3310.Converter
io.gitlab.theevilskeleton.Upscaler
org.gnome.gitlab.YaLTeR.Identity

echo "file sharing"
flatpak install \
com.github.unrud.VideoDownloader \
com.transmissionbt.Transmission \
eu.ithz.umftpd org.filezillaproject.Filezilla \
io.github.giantpinkrobots.varia \
org.nickvision.tubeconverter \
org.jdownloader.JDownloader
