# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/$USER/.oh-my-zsh

ZSH_THEME="intheloop" #spaceship

SPACESHIP_PHP_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_EXEC_TIME_SHOW=false

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  # laravel
  # docker-compose
  extract
  zsh-autosuggestions
  zsh-syntax-highlighting
  autojump 
  fzf # find!
  bgnotify # nofity long task 
  sudo # double esc
)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

#general
alias cat="bat"
alias zshrc='${=EDITOR} ~/.zshrc' # Quick access to the ~/.zshrc file
alias vimrc='${=EDITOR} ~/.vimrc' # Quick access to the ~/.zshrc file

# php
alias pat="php artisan tinker"
alias pah="php artisan horizon"
#alias phpunit="vendor/bin/phpunit"
#alias pu="phpunit"
#alias pf="phpunit --filter"

# git
alias gfaa="gfa && gco develop && ggpull && gco master && ggpull"
alias gclean="git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 git branch -d"  # TEST delete local branch merged with master

# remove the commit from branch
alias grhd="git reset HEAD~ --hard"
# undo the last commit, but leave the changes available
alias grs="git reset HEAD~ --soft"


#zsh
alias reload!=". ~/.zshrc"

# exa
alias ls="exa"
alias l="exa -a"
alias ll="exa -lgh"
alias la="exa -lagh"
alias lt="exa -T"
alias lg="exa -lagh --git"

# debin
alias update="sudo apt update"
alias upgrade="sudo apt upgrade"
alias update_upgrade="sudo apt update && sudo apt upgrade"

# file manipulation
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'

# general 
alias dev="$HOME/dev"

export SMPCPATH=/home/jonaselan/Desktop/setup-my-pc


# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

# checkout git branch (including remote branches) with FZF
fgco() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# git log browser with FZF
fgl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

compress() {
    tar cvzf $1.tar.gz $1
}
