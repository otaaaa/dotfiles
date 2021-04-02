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
export FZF_DEFAULT_OPTS='--height 20% --reverse'
setopt auto_cd
setopt auto_pushd
setopt nobeep
setopt complete_aliases
alias ll="ls -lG"
alias la="ls -laG"
alias load='set -a; source ./.env; set +a;'
alias reload='source ~/.zshrc'
alias repo='cd $(ghq list -p | fzf)'
alias -g C='| wc -l'
alias uuid='uuidgen | tr \[:upper:\] \[:lower:\]'

function keygen() {
  local length=12
  echo "$(openssl rand -base64 $length)"
}

function uuid() {
  uuidgen | tr \[:upper:\] \[:lower:\]
}

function ipv4() {
  ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}

function gip() {
  wget -qO- http://checkip.amazonaws.com
}

# zsh history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_reduce_blanks
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Neovim
alias vim='nvim'

# Git
eval "$(hub alias -s)"

# Docker
alias -g DI='docker images | fzf | awk "{print \$3}"'
alias -g DC='docker ps | fzf | awk "{print \$1}"'
alias dsh='docker run --rm -it $(DI) sh'
alias dat='docker attach $(DC)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -f "dangling=true" -q)'
alias drmv='docker volume rm $(docker volume ls -qf dangling=true)'

# Kubernetes
alias -g KP='$(kubectl get pods | fzf | awk "{print \$1}")'
alias -g KN='$(kubectl get nodes | fzf | awk "{print \$1}")'
alias kc='kubectl'
alias kce='kubectl exec -it KP' # ex. kce -c app ash
alias kcl='kubectl logs -f KP'  # ex. kcl app
alias kdp='kubectl describe pod KP'
alias kdn='kubectl describe node KN'

# Golang
export GOPATH=$HOME/go

# Ruby
eval "$(rbenv init -)"
alias rubocop='docker-compose run --rm app bundle exec rubocop -a'
alias rspec='docker-compose run --rm -e "RAILS_ENV=test" app bundle exec rspec'
alias console='docker-compose run --rm app bin/rails c'
alias routes='docker-compose run --rm app bin/rake routes'
alias ridgepole='docker-compose run --rm app bin/rake ridgepole:apply'
alias run='docker-compose run --rm app'

function cleanup {
  rm -f tmp/pids/server.pid && \
  docker container prune -f && \
  docker volume rm $(docker volume ls -q -f name=redis-data | fzf)
}

# Node.js
eval "$(nodenv init -)"
alias ns="npm ls -g --depth=0"

# Google Cloud Platform
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source <(kubectl completion zsh)
complete -F __start_kubectl kc

function gconfig {
  echo -e "\e[32;1;m$(gcloud config get-value project)"
  if [ ! -z $CLUSTER_NAME ]; then
    echo -e "\e[32;1;m$(kubectl config current-context)"
  fi
}

function gauth {
  source $(find ~/.env/auth/* -type f | fzf)
  gcloud auth activate-service-account \
    --key-file=$GOOGLE_APPLICATION_CREDENTIALS

  kubectl config unset current-context
  if [ ! -z $CLUSTER_NAME ]; then
    gcloud container clusters get-credentials \
      --region $REGION_NAME $CLUSTER_NAME
  fi
  gconfig
}

function proxy {
  source $(find ~/.env/proxy/* -type f | fzf)
  ~/cloud_sql_proxy -instances=$INSTANCE_CONNECTION_NAME=tcp:3306 \
                    -credential_file=$CLOUD_SQL_PROXY_CREDENTIALS
}

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

