#!/bin/sh

# set background
setbg &

# xresources
xrdb -merge "$HOME/.config/Xresources" &

# fix cursor
xsetroot -cursor_name left_ptr &

# map caps lock to escape
setxkbmap -option caps:escape &

# increase key speed
xset r rate 300 50 &

# file syncing
syncthing -no-console -no-browser &

# wm
# stack exec -- xmonad --recompile
# exec xmonad
exec dwm
