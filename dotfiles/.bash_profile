#!/bin/bash -eux
IFS=$'\n\t'

[[ $PATH != *$HOME/bin* ]] && PATH=$PATH:~/bin
[[ $PATH != *$HOME/Library/Python/2.7/bin* ]] && PATH=$PATH:~/Library/Python/2.7/bin
[[ $PATH != */usr/local/opt/gnu-getopt/bin* ]] && PATH=$PATH:/usr/local/opt/gnu-getopt/bin
export PYTHONPATH=/usr/bin/python

BIO_PATH="$HOME/wanderbee/beeswaxio"

# shellcheck disable=SC1090
source ~/.git-completion.bash
# shellcheck disable=SC1090
source ~/.git-prompt.sh

# Colors
green="\\[\\033[0;32m\\]"
blue="\\[\\033[0;34m\\]"
purple="\\[\\033[0;35m\\]"
reset="\\[\\033[0m\\]"

# Change command prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
export PS1="$purple\\u@\\h $blue\\W$green\$(__git_ps1)\\n$purple$ $reset"

export NVM_DIR="$HOME/.nvm"
if [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    # shellcheck disable=SC1091
    source /usr/local/opt/nvm/nvm.sh
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck disable=SC1090
    source "$NVM_DIR/nvm.sh"
else
    echo "No nvm.sh file found in /usr/local/opt/nvm/ or $NVM_DIR/nvm.sh"
fi

export PYTHONDONTWRITEBYTECODE=1
export HISTTIMEFORMAT="%d/%m/%y %T "

# Config profiles
function prof {
    if [[ "$1" == "code" ]]; then
        code ~/.bash_profile
    else
        vim ~/.bash_profile
    fi
}
function gitprof {
    vim ~/.gitconfig
}
function reprof {
    # shellcheck disable=SC1090
    source ~/.bash_profile
}
function vimprof {
    vim ~/.vimrc
}
function setup {
    local setup_path="$HOME/Desktop/dev/setup"
    if [[ ! -d "$setup_path" ]]; then
        echo "$setup_path doesn't exist"
    else
        cd "$setup_path"
    fi
}

# Dirs
function sbx {
    cd ~/Desktop/sandbox
}
function wb {
    local wb_path="$HOME/wanderbee"
    if [[ -d "$wb_path" ]]; then
        cd "$wb_path"
    else
        echo "$wb_path doesn't exist"
    fi
}

# Apps
function workwork {
    open /Applications/Mail.app
    open /Applications/Slack.app
    open /Applications/Calendar.app
    open /Applications/Typora.app
    open /Applications/Spotify.app
    wb
}

# Commands
function npr {
    npm run "$1"
}
function tunnel {
    wb && vagrant ssh
}
function up {
    wb && vagrant up && code
}

# Bind fzf bash history search to ctrl + r
bind "$(bind -s | grep '^"\\C-r"' | sed 's/"/"\\C-x/' | sed 's/"$/\\C-m"/')"

eval "$(thefuck --alias 2>/dev/null)"
