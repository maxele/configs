#!/bin/bash
colors=($(cat ~/.cache/wal/colors-kitty.conf | sed -e "/^$/d" -e "s/.* //"))
bg="${colors[7]}"
fg="${colors[2]}"
# active="%{F${colors[2]}}%{F-}"
# inactive="%{F${colors[4]}}%{F-}"
# empty="%{F${colors[4]}}%{F-}"
active=""
inactive=""
LINE="|"
left() {
  #WORKSPACE=$(herbstclient tag_status | sed -e "s/.*#\([a-zA-Z]*\).*/\1/")
  a=$(herbstclient tag_status | sed -e "s/[[:space:]]//g" -e "s/[a-zA-Z0-9()]//g")
  WORKSPACE=""
  for (( i=0; i<${#a}; i++ )); do 
    if [ ${a:$i:1} == "." ]; then
      WORKSPACE+="$inactive"
    elif [ ${a:$i:1} == ":" ]; then
      WORKSPACE+="$inactive"
    else
      WORKSPACE+="$active"
    fi
    WORKSPACE+=" "
  done
  #WORKSPACE=${WORKSPACE:0:${#a}*2-1}
  echo -n " $WORKSPACE"
}
center() {
  WINDOWTITLE=$(xdotool getwindowname $(xdotool getactivewindow 2>/dev/null) 2>/dev/null)
  if [[ -n $WINDOWTITLE ]]; then
    echo -n "$WINDOWTITLE"
  fi
}
right() {
  DATE=" $(date +%H:%M)"
  # PulseAudio
  S=$(pactl list | grep $(pactl get-default-sink) --after-context=7 | grep Mute | head -n 1 | sed "s/.* //")
  VOL=""
  if [ $S == "no" ]; then
    VOL=$(pactl list | grep $(pactl get-default-sink) --after-context=7 | grep Volume: | head -n 1 | cut -d'/' -f2 | sed "s/ //g")
    VOL=" $VOL"
  else
    VOL="婢"
  fi
  # Alsa
  # S=$(amixer sget Master | grep "dB" | sed -e "s/.*\[//" -e "s/]//")
  # VOL=""
  # if [ $S == "on" ]; then
  #   VOL=$(amixer sget Master | grep "dB" | sed -e "s/].*$//" -e "s/.*\[//")
  #   VOL="$ARROW_LEFT $VOL"
  # else
  #   VOL="$ARROW_LEFT muted"
  # fi
  BAT=""
  # BAT=" $(acpi | cut -d" " -f4 | sed "s/\(.*%\).*/\1/") $LINE"
  echo -n "$BAT $VOL $LINE $DATE "
}

if [[ $(pgrep lemonbar) ]]; then
  pkill lemonbar
  #herbstclient pad 0 0
else
  while true; do
    echo "%{c}$(center)%{r}$(right)"
    # echo "%{l}$(left)%{c}$(center)%{r}$(right)"
    sleep 0.05
  done | lemonbar -B $bg -F $fg -f "Delugia Mono:size=10" -g 2560x25+0+0 -o 1 HDMI-0 &
  sleep 0.05
  while true; do
    echo "%{l}$(left)"
    sleep 0.05
  done | lemonbar -B $bg -F $fg -f "Delugia Mono:size=14" -g 500x25+0+0 -o 1 HDMI-0 &
fi
