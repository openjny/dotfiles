# Ubuntu 24.04 LTS

## キーボード

```bash
SCHEMA="org.gnome.desktop.peripherals.keyboard"

# 現状確認
for key in $(gsettings list-keys $SCHEMA); do
  value=$(gsettings get $SCHEMA $key)
  echo "$key: $value"
done

# 設定変更
gsettings set $SCHEMA repeat-interval 20
gsettings set $SCHEMA delay 200
```
