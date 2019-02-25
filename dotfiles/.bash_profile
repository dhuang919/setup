#!/bin/bash -eux
IFS=$'\n\t'

[[ $PATH != *$HOME/bin* ]] && PATH=$PATH:~/bin
[[ $PATH != *$HOME/Library/Python/2.7/bin* ]] && PATH=$PATH:~/Library/Python/2.7/bin
PYTHONPATH=/usr/bin/python

BIO_PATH=/mnt/vm/home/derekh/src/beeswaxio/beeswax

# shellcheck disable=SC1090
source ~/.bash_private
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
GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
PS1="$purple\\u@\\h $blue\\W$green\$(__git_ps1)\\n$purple$ $reset"

NVM_DIR="$HOME/.nvm"
if [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    # shellcheck disable=SC1091
    source /usr/local/opt/nvm/nvm.sh
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck disable=SC1090
    source "$NVM_DIR/nvm.sh"
else
    echo "No nvm.sh file found in /usr/local/opt/nvm/ or $NVM_DIR/nvm.sh"
fi

PYTHONDONTWRITEBYTECODE=1

export PS1
export PATH
export NVM_DIR
export PYTHONPATH
export GIT_PS1_SHOWDIRTYSTATE
export PYTHONDONTWRITEBYTECODE

###################
# Config profiles #
###################
function prof {
    if [[ "$1" == "code" ]]; then
        code ~/.bash_profile
    else
        nano ~/.bash_profile
    fi
}
function gitprof {
    nano ~/.gitconfig
}
function reprof {
    # shellcheck disable=SC1090
    source ~/.bash_profile
}
function setup {
    local readonly path="$HOME/Desktop/dev/setup"
    if [[ ! -d "$path" ]]; then
        echo "$path doesn't exist"
    else
        cd "$path"
    fi
}

########
# Dirs #
########
function sand {
    cd ~/Desktop/sandbox
}
function jd {
    local readonly path="$HOME/Desktop/dev/janetandderek"
    if [[ -d "$path" ]]; then
        cd "$path"
    else
        echo "$path doesn't exist"
    fi
}
function wb {
    local readonly path="$HOME/wanderbee"
    if [[ -d $path ]]; then
        cd $path
    else
        echo "$path doesn't exist"
    fi
}
function bw {
    if [[ -d /mnt/vm/home/derekh ]]; then
        code "$BIO_PATH"
    else
        echo "Not mounted!"
    fi
}
function ui {
    if [[ -d /mnt/vm/home/derekh ]]; then
        code "$BIO_PATH/beeswax/buzz_ui"
    else
        echo "Not mounted!"
    fi
}
function fes {
    if [[ -d /mnt/vm/home/derekh ]]; then
        code "$BIO_PATH/beeswax/buzz_fes_ui"
    else
        echo "Not mounted!"
    fi
}
function api {
    if [[ -d /mnt/vm/home/derekh ]]; then
        code "$BIO_PATH/beeswax/buzz_api"
    else
        echo "Not mounted!"
    fi
}

########
# Apps #
########
function workwork {
    open /Applications/Mail.app
    open /Applications/Slack.app
    open /Applications/Calendar.app
    open /Applications/Typora.app
    open /Applications/Spotify.app
}

############
# Commands #
############
function npr {
    npm run "$1"
}
function tunnel {
    wander && vagrant ssh
}
function mvm {
    wander && vagrant sshfs
}
function uvm {
    wander && vagrant halt
}
function bp {
    setup
    git pull
    reprof
    cd -
}

# Bind fzf bash history search to ctrl + r
bind "$(bind -s | grep '^"\\C-r"' | sed 's/"/"\\C-x/' | sed 's/"$/\\C-m"/')"

eval $(thefuck --alias 2>/dev/null)
