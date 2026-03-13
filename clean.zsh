#!/usr/bin/env zsh

source stowdirs

DOT_FILES="$HOME/.dotfiles"

DOTCONFIG_TARGET="$HOME/.config"
WIDGET_TARGET="$HOME/.local/share/plasma/plasmoids"
SPLASH_TARGET="$HOME/.local/share/plasma/look-and-feel"

pushd "$DOT_FILES" 

unstow_list() {
  local list=$1
  local target=$2

  local folders=(${(s:,:)list})

  for folder in "${folders[@]}"; do
    echo "Removing $folder from $target"
    stow -D "$folder" -t "$target" 2>/dev/null
  done
}

unstow_list "$STOW_TO_DOTCONFIG" "$DOTCONFIG_TARGET"

unstow_list "$STOW_TO_WIDGET" "$WIDGET_TARGET"

unstow_list "$STOW_TO_SPLASH" "$SPLASH_TARGET"

popd 
