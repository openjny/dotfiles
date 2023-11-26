# Ubuntu 22.04

## キーボード

### 連続入力

調整は Accessibility から ([ref](https://help.ubuntu.com/stable/ubuntu-help/keyboard-repeat-keys.html.en))

```bash
SCHEMA="org.gnome.desktop.peripherals.keyboard"
gsettings set $SCHEMA repeat true
gsettings set $SCHEMA delay 250
gsettings set $SCHEMA repeat-interval 20
```
