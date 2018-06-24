# Zplug
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

# zsh generic config
export LANG=ja_JP.UTF-8
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export PURE_PROMPT_SYMBOL="$" # pure theme
setopt auto_cd
setopt auto_pushd
setopt nobeep
setopt complete_aliases
alias ll="ls -lG"
alias la="ls -laG"
alias lap="ls -la | peco"
alias reload='source ~/.zshrc'
alias repo='cd $(ghq list -p | peco)'
alias pwdy='pwd | pbcopy'

function keygen() {
  local length=12
  echo "$(openssl rand -base64 $length)"
}

# zsh history
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

if which peco &> /dev/null; then
  function peco_select_history() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
  }

  zle -N peco_select_history
  bindkey '^R' peco_select_history
fi

# Neovim
alias vim='nvim'

# Git
eval "$(hub alias -s)"
alias gl="git log --no-merges --date=short --pretty='format:%C(yellow)%h %C(green)%cd %C(blue)%an%C(red)%d %C(reset)%s'"

# Docker
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias drmv='docker volume rm $(docker volume ls -q)'

# Golang
export GOPATH=$HOME/go

# Ruby
eval "$(rbenv init -)"
alias cop='docker-compose run --rm app bundle exec rubocop -a'
alias spec='docker-compose run --rm app bundle exec rspec'
alias console='docker-compose run --rm app bin/rails c'
alias routes='docker-compose run --rm app bin/rake routes'
alias ridgepole='docker-compose run --rm app bin/rake ridgepole:apply'
alias run='docker-compose run --rm app'

# Node.js
eval "$(nodenv init -)"
alias ns="npm ls -g --depth=0"

# Google Cloud Platform
export PROJECT_ID="$(gcloud config get-value project -q)"
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

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

