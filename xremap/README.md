# xremap

https://github.com/k0kubun/xremap

## インストール

```bash
echo $XDG_CONFIG_HOME
# x11 

cargo install xremap --features x11

# running xremap without sudo
sudo gpasswd -a $USER input
echo 'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules
```

## 管理

### systemd で管理

```bash
XREMAP=$(which xremap)
XREMAP=$(readlink -f $XREMAP)
XREMAP_CONFIG="$HOME/.config/xremap/config.yml"

cat <<EOF > "~/.config/systemd/user/xremap.service"
[Unit]
Description=xremap

[Service]
KillMode=process
ExecStart=$XREMAP --watch $XREMAP_CONFIG
ExecStop=/usr/bin/killall xremap
Type=simple
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user enable xremap
systemctl --user start xremap
```

`--watch` を指定していることによって、キーボードの接続を検知すると自動的に新たな input デバイスにも設定が適用される (便利)。

再起動したければ `systemctl --user restart xremap` で良い。`./bin/restart-xremap` にも同様の処理を記述している。

### Startup Application で管理 (非推奨)

[xremap.desktop](./xremap.desktop) を `~/.config/autostart/` に配置する。
