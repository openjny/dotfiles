#!/bin/bash

cmd_exists() {
  command -v "$1" >/dev/null 2>&1
}

# if [ -x /usr/local/bin/xkeysnail ] && [ -e $HOME/xkeysnail-config.py ]; then
#     xhost +SI:localuser:root
#     sudo DISPLAY=:1 /usr/local/bin/xkeysnail $HOME/xkeysnail-config.py &
# fi

if cmd_exists setxkbmap && cmd_exists xmodmap && [ -e $HOME/.Xmodmap ]; then
    setxkbmap -option
    xmodmap $HOME/.Xmodmap
fi
