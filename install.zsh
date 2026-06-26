#!/usr/bin/env zsh

source stowdirs.zsh

DOT_FILES=$HOME/Documents/github/.dotfiles
CONFIG_TARGET=$HOME/.config
WIDGET_TARGET="$HOME/.local/share/plasma/plasmoids"
SPLASH_TARGET="$HOME/.local/share/plasma/look-and-feel"

pushd $DOT_FILES

stow_list() {
  local list=$1
  local target=$2

  mkdir -p $target

  for folder in ${(s:,:)list}; do
    echo "Stowing $folder into $target"
    stow -D $folder
    stow $folder -t $target
  done
}

stow_list $STOW_TO_DOTCONFIG $CONFIG_TARGET

stow_list $STOW_TO_WIDGET $WIDGET_TARGET

stow_list $STOW_TO_SPLASH $SPLASH_TARGET

popd
