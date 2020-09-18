#!/bin/sh

# set background
setbg &

# xresources
xrdb -merge "$HOME/.config/Xresources" &

# fix cursor
# xsetroot -cursor_name left_ptr &

# map caps lock to escape
setxkbmap -option caps:escape &

# increase key speed
xset r rate 300 50 &

# file syncing
syncthing -no-console -no-browser &

# turn off screen timeout
xset s off &
# xset s on
xset -dpms &
# xset +dpms

picom &

dbuslaunch="`which dbus-launch 2>/dev/null`"
if [ -n "$dbuslaunch" ] && [ -x "$dbuslaunch" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  if [ -n "$command" ]; then
    command="$dbuslaunch --exit-with-session $command"
  else
    eval `$dbuslaunch --sh-syntax --exit-with-session`
  fi
fi

# wm
# stack exec -- xmonad --recompile
exec xmonad
# exec dwm
