#!/bin/bash

orig=("~/.config/herbstluftwm/"\
  "~/.config/picom.conf"\
  "~/.config/kitty/"\
  "~/.config/nvim/"
)

debug=0

function install() {
  a="o"
  while [ ! "$a" = "y" -a ! "$a" = "n" ]; do
    echo "The following configs are going to be overwritten!"
    for f in ${orig[@]}; do
      echo "  $f"
    done
    echo -n "Are you sure you want to proceed? (y/n) "
    read a
    if [ ! "$a" = "y" -a ! "$a" = "n" ]; then
      echo ""
      echo "You can only choose \"y\" or \"n\"!"
    fi
  done 

  if [ "$a" = "y" ]; then
    echo "installing..."
    mkdir -p "/home/max/config/"
    for f in ${orig[@]}; do
      if [ "${f: -1}" == "/" ]; then
        f="${f::-1}"
      fi
      a="cp -r ./dotfiles/$(echo $f | sed "s/.*\///") $(echo $f | sed -E "s/(.*\/).*/\1/")"
      a="$(echo $a | sed "s/\.config/config/g")"
      a=$(echo $a | sed "s/~/\/home\/$(whoami)/")
      echo $a
      bash -c "$a"
    done
    echo -e "\nuse -f flag for installing fonts"
  else
    echo "cancelling..."
  fi
}

function backup() {
  echo "backing up..."
  rm -rf ./dotfiles/
  mkdir -p ./dotfiles/
  for f in ${orig[@]}; do
    # if [ "${f: -1}" == "/" ]; then
    #   f="${f::-1}"
    # fi
    f=$(echo $f | sed "s/~/\/home\/$(whoami)/")
    cp $f ./dotfiles/ -r
    echo "Backing up $f"
  done
}

function fonts() {
  echo "installing fonts..."
  for f in $(pwd)/fonts/*; do
    a="sudo mv $f /usr/share/fonts/TTF/"
    echo $a
    sudo $a
    #bash -c $a
  done;
}

function help() {
  if [ $debug ]; then
    echo -e "Debug is enabled\n"
  fi
  echo "Valid options are:"
  echo "  -i    Install dotfiles"
  echo "  -b    Copy existing dotfiles into backup directory"
  echo "  -f    Install fonts (sudo required)"
  echo ""
  echo "Files which are going to be backed up:"
  for f in ${orig[@]}; do
    echo "  $f"
  done
}

while getopts "ibfh" opt; do
  case $opt in
    i)
      install
      exit 1
      ;;
    b)
      backup
      exit 1
      ;;
    h)
      help
      exit 1
      ;;
    f)
      fonts
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

install
