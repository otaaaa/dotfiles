#!/bin/zsh

# clone repository
if [[ ! -e ${HOME}/.dotfiles ]]; then
  git clone https://github.com/otaaaa/dotfiles.git ${HOME}/.dotfiles
else
  git -C ${HOME}/.dotfiles pull
fi

# link dotfiles
cd ${HOME}/.dotfiles
for name in *; do
  if [[ ${name} != 'setup' ]] && [[ ${name} != 'config' ]] && [[ ${name} != 'README.md' ]]; then
    if [[ -L ${HOME}/.${name} ]]; then
      unlink ${HOME}/.${name}
    fi
    ln -sfv ${PWD}/${name} ${HOME}/.${name}
  fi
done

# link config
if [[ ! -d ${HOME}/.config ]]; then
  mkdir ${HOME}/.config
fi
cd ./config
for name in *; do
  if [[ -L ${XDG_CONFIG_HOME:-$HOME/.config}/$name ]]; then
    unlink ${XDG_CONFIG_HOME:-$HOME/.config}/$name
  fi
  ln -sfv ${PWD}/${name} ${XDG_CONFIG_HOME:-$HOME/.config}/${name}
done

# zplug
if [[ ! -d ${HOME}/.zplug ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ${HOME}/.zshrc

# Install brew packages
cd ${HOME} && brew bundle --file=${HOME}/.dotfiles/setup/Brewfile
