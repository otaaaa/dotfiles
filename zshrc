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
alias kc='kubectl'
alias kce='kubectl exec -it KP'
alias kcl='kubectl logs -f KP'

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

function gconfig {
  echo "Project     [$(gcloud config get-value project)]"
  echo "K8s Context [$(kubectl config current-context)]"
}

function gauth {
  source $(find ~/.env/auth/* -type f | fzf)
  gcloud auth activate-service-account $GOOGLE_SERVICE_ACCOUNT \
              --key-file $GOOGLE_APPLICATION_CREDENTIALS \
              --project=$GOOGLE_PROJECT_ID
  # gcloud container clusters get-credentials -z $ZONE_NAME $CLUSTER_NAME
  gcloud container clusters get-credentials --region $REGION_NAME $CLUSTER_NAME
  gconfig
}

function proxy {
  source $(find ~/.env/proxy/* -type f | fzf)
  ~/cloud_sql_proxy -instances=$INSTANCE_CONNECTION_NAME=tcp:3306 \
                    -credential_file=$CLOUD_SQL_PROXY_CREDENTIALS
}

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

