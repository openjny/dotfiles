#!/bin/bash

cmd_exists() {
  command -v "$1" >/dev/null 2>&1
}
# if [ -x /usr/local/bin/xkeysnail ]; then
#     xhost +SI:localuser:root
#     sudo DISPLAY=:1 /usr/local/bin/xkeysnail /home/openjny/xkeysnail-config.py &
# fi

if cmd_exists setxkbmap && cmd_exists xmodmap && [ -e ~/.Xmodmap ]; then
  echo "Load and execute ~/.Xmodmap"

  # backup
  if [[ ! -e ~/.Xmodmap_default ]]; then
    xmodmap -pke > ~/.Xmodmap_default
  fi
  
  setxkbmap -option
  xmodmap ~/.Xmodmap
fi
