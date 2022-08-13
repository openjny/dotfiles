# xremap

https://github.com/k0kubun/xremap

```bash
VERSION="v0.5.0"
XREMAP="/usr/local/bin/xremap"
XREMAP_CONFIG_DIR="/home/$USER/.config/xremap"
XREMAP_CONFIG="$XREMAP_CONFIG_DIR/config.yml"

# install xremap
cd /tmp
wget "https://github.com/k0kubun/xremap/releases/download/$VERSION/xremap-linux-x86_64-gnome.zip"
unzip xremap-linux-x86_64-gnome.zip
chmod +x xremap
sudo mv xremap $XREMAP

# running xremap without sudo
sudo gpasswd -a $USER input
echo 'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules

# create config.yml
[ -d "$XREMAP_CONFIG_DIR" ] || mkdir -p "$XREMAP_CONFIG_DIR"

ln -sf ~/dotfiles/xremap/config.yml $XREMAP_CONFIG
# vim $XREMAP_CONFIG

# systemd (xremap.service)
SYSTEMD_SERVICE_DIR="~/.config/systemd/user"
[ -d "$SYSTEMD_SERVICE_DIR" ] || mkdir -p "$SYSTEMD_SERVICE_DIR"
cat <<EOF > "$SYSTEMD_SERVICE_DIR/xremap.service"
[Unit]
Description=xremap

[Service]
KillMode=process
ExecStart=$XREMAP $XREMAP_CONFIG
ExecStop=/usr/bin/killall xremap
Restart=always
Environment=DISPLAY=:0.0

[Install]
WantedBy=graphical.target
EOF
sudo systemctl enable xremap

# autostart program
AUTOSTART_DIR="~/.config/autostart"
[ -d "$AUTOSTART_DIR" ] || mkdir -p "$AUTOSTART_DIR"
cat <<EOF > "$AUTOSTART_DIR/xremap.desktop"
[Desktop Entry]
Type=Application
Exec=$XREMAP $XREMAP_CONFIG
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=xremap
Name=xremap
Comment[en_US]=
Comment=
EOF
```
