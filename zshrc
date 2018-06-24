source ~/.zplug/init.zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load

export PURE_PROMPT_SYMBOL="$"
setopt auto_cd
setopt auto_pushd
setopt nobeep
setopt complete_aliases
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

export LANG=ja_JP.UTF-8
export EDITOR=nvim
export GOPATH=$HOME/go
export XDG_CONFIG_HOME=~/.config

eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(hub alias -s)"

alias ll="ls -lG"
alias la="ls -laG"
alias lap="ls -la | peco"
alias ns="npm ls -g --depth=0"
alias vim='nvim'
alias be='bundle exec'
alias repo='cd $(ghq list -p | peco)'
alias gl="git log --no-merges --date=short --pretty='format:%C(yellow)%h %C(green)%cd %C(blue)%an%C(red)%d %C(reset)%s'"
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias drmv='docker volume rm $(docker volume ls -q)'
alias pwdy='pwd | pbcopy'
alias reload='source ~/.zshrc'
alias cop='docker-compose run --rm app bundle exec rubocop -a'
alias spec='docker-compose run --rm app bundle exec rspec'
alias console='docker-compose run --rm app bin/rails c'
alias routes='docker-compose run --rm app bin/rake routes'
alias ridgepole='docker-compose run --rm app bin/rake ridgepole:apply'
alias run='docker-compose run --rm app'

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

if which peco &> /dev/null; then
  function peco_select_history() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
  }

  zle -N peco_select_history
  bindkey '^R' peco_select_history
fi

function keygen() {
  local length=12
  echo "$(openssl rand -base64 $length)"
}

function region {
  cat <<EOF
- provider: GCP
  region: asia-northeast1
  availability_zone:
  - asia-northeast1-a
  - asia-northeast1-b
  - asia-northeast1-c
- provider: AWS
  region: ap-northeast-1
EOF
}

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
