#!/bin/zsh
readonly UNINSTALL_TARGETS=(
  gitconfig
  gitignore_global
  gitmessage
  zshrc
  pryrc
  Library/Preferences/com.googlecode.iterm2.plist
  config/iterm
  config/nvim
)

echo 'remove dotfiles? (y/N)'
read confirmation
if [[ $confirmation = "y" || $confirmation = "Y" ]]; then
  for target in ${UNINSTALL_TARGETS[@]}; do
    unlink ${HOME}/.${target}
  done
fi
