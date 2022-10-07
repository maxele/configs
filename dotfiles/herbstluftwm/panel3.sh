#!/bin/bash
colors=($(cat ~/.cache/wal/colors-kitty.conf | sed -e "/^$/d" -e "s/.* //"))
bg="%{B${colors[7]}}"
fg="${colors[2]}"
LINE="|"
#ARROW_RIGHT="%{B-}%{F${colors[7]}}$bg%{F-}"
#ARROW_LEFT="%{B-}%{F${colors[7]}}$bg%{F-}"
ARROW_RIGHT="%{B-}%{F${colors[7]}}$bg%{F-}"
ARROW_LEFT="%{B-}%{F${colors[7]}}$bg%{F-}"
clear_bg="%{B-}"

left() {
  #WORKSPACE=$(herbstclient tag_status | sed -e "s/.*#\([a-zA-Z]*\).*/\1/")
  if [[ $1 -eq 0 ]]; then
    active=" "
    inactive=" "
    empty=" "
  else
    active=""
    inactive="%{F${colors[4]}}%{F-}"
    empty="%{F${colors[4]}}%{F-}"
  fi
  # active="%{F${colors[2]}}%{F-}"
  # inactive="%{F${colors[4]}}%{F-}"
  a=$(herbstclient tag_status | sed -e "s/[[:space:]]//g" -e "s/[a-zA-Z0-9()]//g")
  WORKSPACE=""
  for (( i=0; i<${#a}; i++ )); do 
    if [ ${a:$i:1} == "." ]; then
      WORKSPACE+="$empty"
    elif [ ${a:$i:1} == ":" ]; then
      WORKSPACE+="$inactive"
    else
      WORKSPACE+="$active"
    fi
    WORKSPACE+=" "
  done
  WORKSPACE="${WORKSPACE:0:${#WORKSPACE}-1}"
  if [[ $1 -eq 0 ]]; then
    l=${#WORKSPACE}
    l=$l+2
    WORKSPACE=""
    while [[ $l -ge 0 ]]; do
      WORKSPACE="${WORKSPACE} "
      l=${l}-1
    done
    echo -n "$bg $WORKSPACE$ARROW_RIGHT"
  else
    echo -n "$WORKSPACE"
  fi
}
center() {
  WINDOWTITLE=$(xdotool getwindowname $(xdotool getactivewindow 2>/dev/null) 2>/dev/null)
  if [[ -n $WINDOWTITLE ]]; then
    echo -n "$bg$ARROW_LEFT$WINDOWTITLE$ARROW_RIGHT$clear_bg"
  fi
}
right() {
  DATE=" $(date +%H:%M)"
  BAT=" $(acpi | cut -d" " -f4 | sed "s/\(.*%\).*/\1/")"
  # PulseAudio
  # S=$(pactl list | grep $(pactl get-default-sink) --after-context=7 | grep Mute | head -n 1 | sed "s/.* //")
  # VOL=""
  # if [ $S == "no" ]; then
  #   VOL=$(pactl list | grep $(pactl get-default-sink) --after-context=7 | grep Volume: | head -n 1 | cut -d'/' -f2 | sed "s/ //g")
  #   VOL="$ARROW_LEFT  $VOL"
  # else
  #   VOL="$ARROW_LEFT 婢"
  # fi
  # Alsa
  S=$(amixer sget Master | grep "dB" | sed -e "s/.*\[//" -e "s/]//")
  VOL=""
  if [ $S == "on" ]; then
    VOL=$(amixer sget Master | grep "dB" | sed -e "s/].*$//" -e "s/.*\[//")
    VOL="$ARROW_LEFT$VOL"
  else
    VOL="$ARROW_LEFT婢"
  fi
  echo -n "$bg$VOL $LINE $BAT $LINE $DATE $clear_bg"
}

if [[ $(pgrep lemonbar) ]]; then
  pkill lemonbar
  #herbstclient pad 0 0
else
  while true; do
    echo "%{l}$(left 0)%{c}$(center)%{r}$(right)"
    sleep 0.5
  done | lemonbar -B \#00000000 -F $fg -f "CaskaydiaCove Nerd Font Mono:size=16" -g 2240x23+0+5 -o 1 &
  sleep 0.05

  while true; do
    echo "%{l}$(left 1)"
    sleep 0.05
  done | lemonbar -B \#00000000 -F \#FFF -g 2233x34+7+0 -f "CaskaydiaCove Nerd Font Mono:size=20" &
fi
