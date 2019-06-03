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
alias -g X='| xargs'
alias -g C='| wc -l'

function keygen() {
  local length=12
  echo "$(openssl rand -base64 $length)"
}

function ipv4() {
  ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
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

# Docker
alias -g DI='docker images | peco | awk "{print \$3}"'
alias -g DC='docker ps | peco | awk "{print \$1}"'
alias dsh='docker run --rm -it $(DI) sh'
alias dat='docker attach $(DC)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -f "dangling=true" -q)'
alias drmv='docker volume rm $(docker volume ls -qf dangling=true)'

# Kubernetes
source <(kubectl completion zsh)
alias -g KP='$(kubectl get pods | peco | awk "{print \$1}")'
alias -g KD='$(kubectl get deploy | peco | awk "{print \$1}")'
alias -g KS='$(kubectl get svc | peco | awk "{print \$1}")'
alias -g KI='$(kubectl get ing | peco | awk "{print \$1}")'
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
  docker-compose stop && \
  docker container prune -f && \
  docker volume rm $REDIS_CONTAINER_NAME && \
  rm -f tmp/pids/server.pid
}

# Node.js
eval "$(nodenv init -)"
alias ns="npm ls -g --depth=0"

# Google Cloud Platform
export PROJECT_ID="$(gcloud config get-value project -q)"
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

function proxy {
  ~/cloud_sql_proxy -instances=$INSTANCE_CONNECTION_NAME=tcp:3306 \
                    -credential_file=$CLOUD_SQL_PROXY_CREDENTIALS
}

function gauth {
  source $(find ~/.env -type f | peco)
  gcloud auth activate-service-account $GOOGLE_SERVICE_ACCOUNT --key-file $GOOGLE_APPLICATION_CREDENTIALS --project=$GOOGLE_PROJECT_ID
  gcloud container clusters get-credentials -z $ZONE_NAME $CLUSTER_NAME
}

# ansible-vault
function encrypt {
  tmpfile=$(mktemp)
  echo $VAULT_PASSWORD >> $tmpfile
  ansible-vault encrypt --vault-password-file=$tmpfile $@
  rm $tmpfile
}

function decrypt {
  tmpfile=$(mktemp)
  echo $VAULT_PASSWORD >> $tmpfile
  ansible-vault decrypt --vault-password-file=$tmpfile $@
  rm $tmpfile
}

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

