# xremap

https://github.com/k0kubun/xremap

## インストール

```bash
# 環境の確認
echo $XDG_CONFIG_HOME
# x11 

# インストール (最新情報は README を参照)
cargo install xremap --features x11

# sudo なしで実行するための設定 (最新情報は README を参照)
sudo gpasswd -a $USER input
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules

# テンプレート設定をダウンロード
mkdir -p "$HOME/.config/xremap"
wget -q https://github.com/openjny/dotfiles/raw/refs/heads/master/xremap/config.yml -O "$HOME/.config/xremap/config.yml"
```

## Mozc 設定

1. `ibus` なり `fcitx5-mozc` なりを使って Mozc が使える状態を作っておく。
2. Mozc のキーマップエディターを開き、設定をエクスポートする。
3. エクスポートしたファイルを編集する

    例えば、`Hiragana` を IME スイッチャーにしている場合は、次のように IMEOff/On を書き換える。
    ```
    Composition	Hiragana	IMEOff
    Conversion	Hiragana	IMEOff
    DirectInput	Hiragana	IMEOn
    Precomposition	Hiragana	IMEOff
    ```
4. 編集後のキーマップをインポートする。


## 管理

### systemd で管理

```bash
XREMAP=$(which xremap)
XREMAP=$(readlink -f $XREMAP)
XREMAP_CONFIG="$HOME/.config/xremap/config.yml"

if [ ! -d "$HOME/.config/systemd/user" ]; then
  mkdir -p "$HOME/.config/systemd/user"
fi
cat <<EOF > "$HOME/.config/systemd/user/xremap.service"
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

ポイント:
- `--watch` を指定していることによって、キーボードの接続を検知すると自動的に新たな input デバイスにも設定が適用される (便利)。
- 再起動したければ `systemctl --user restart xremap` で良い。

### Startup Application で管理 (非推奨)

[xremap.desktop](./xremap.desktop) を `~/.config/autostart/` に配置する。
