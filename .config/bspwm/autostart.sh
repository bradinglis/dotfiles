#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

$HOME/.config/polybar/launch.sh &

xsetroot -cursor_name left_ptr &
run sxhkd -c ~/.config/bspwm/sxhkd/sxhkdrc &

# conky -c $HOME/.config/bspwm/system-overview &
# run variety &
# run nm-applet &
# run pamac-tray &
run xfce4-power-manager &
# numlockx on &
# picom --config $HOME/.config/bspwm/picom.conf &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &

setxkbmap -option caps:escape
run onedrivegui &

#nitrogen --restore &
#run caffeine &
#run vivaldi-stable &
#run firefox &
#run thunar &
#run dropbox &
#run insync start &
#run discord &
#run spotify &
#run atom &
