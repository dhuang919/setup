#!/bin/bash -eux
IFS=$'\n\t'

PATH=$PATH:~/bin
PYTHONPATH=/usr/bin/python

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
if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
  # shellcheck disable=SC1091
  source /usr/local/opt/nvm/nvm.sh
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck disable=SC1090
  source "$NVM_DIR/nvm.sh"
else
  echo "No nvm.sh file found in /usr/local/opt/nvm/ or $NVM_DIR/nvm.sh"
fi

PYTHONDONTWRITEBYTECODE=1

export PS1
export PATH
export VM_IP
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
function vmprof {
  if [[ -d /mnt && -d /mnt/vm && -d /mnt/vm/home && -d /mnt/vm/home/derekh ]]; then
    if [[ "$1" == "code" ]]; then
      code /mnt/vm/home/derekh/.bash_personal
    else
      nano /mnt/vm/home/derekh/.bash_personal
    fi
  else
    echo "Not mounted!"
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
  if ! [[ -d "$HOME/Desktop/keybase/osx-setup" ]]; then
    echo "Desktop/keybase/osx-setup doesn't exist"
  elif [[ "$1" == "code" ]]; then
    code ~/Desktop/keybase/osx-setup/setup.sh
  else
    nano ~/Desktop/keybase/osx-setup/setup.sh
  fi
}

########
# Dirs #
########
function sand {
  cd ~/Desktop/Sandbox
}
function jd {
  if [[  -d "$HOME/Desktop/keybase" && -d "$HOME/Desktop/keybase/janetandderek" ]]; then
    cd ~/Desktop/keybase/janetandderek
  else
    echo "Something doesn't exist in Desktop/keybase/janetandderek"
  fi
}
function bw {
  if [[ -d /mnt && -d /mnt/vm && -d /mnt/vm/home && -d /mnt/vm/home/derekh ]]; then
    code "$BIO_PATH"
  else
    echo "Not mounted!"
  fi
}
function ui {
  if [[ -d /mnt && -d /mnt/vm && -d /mnt/vm/home && -d /mnt/vm/home/derekh ]]; then
    code "$BIO_PATH/beeswax/buzz_ui"
  else
    echo "Not mounted!"
  fi
}
function fes {
  if [[ -d /mnt && -d /mnt/vm && -d /mnt/vm/home && -d /mnt/vm/home/derekh ]]; then
    code "$BIO_PATH/beeswax/buzz_fes_ui"
  else
    echo "Not mounted!"
  fi
}
function api {
  if [[ -d /mnt && -d /mnt/vm && -d /mnt/vm/home && -d /mnt/vm/home/derekh ]]; then
    code "$BIO_PATH/beeswax/buzz_api"
  else
    echo "Not mounted!"
  fi
}
function rake_tasks {
  code ~/Desktop/rake
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
function ptunnel {
  if [[ -z ${PERSONAL_VM_IP+x} ]]; then
    echo "PERSONAL_VM_IP doesn't exist"
  else
    ssh derekh@$PERSONAL_VM_IP
  fi
}
function tunnel {
  if [[ -z ${VM_IP+x} ]]; then
    echo "VM_IP doesn't exist"
  else
    ssh derekh@$VM_IP
  fi
}
function uvm {
  echo "Unmounting..."
  echo
  sudo umount -f /mnt/vm
}
function mvm {
  local VM="${1:-}"

  if [[ -z ${VM_IP+x} ]] || [[ -z ${PERSONAL_VM_IP+x} ]]; then
    echo "VM_IP/PERSONAL_VM_IP don't exist"
  else
    echo "Mounting..."
    echo
    if [[ "$VM" = "p" ]]; then
      sudo sshfs -o allow_other,defer_permissions,transform_symlinks,follow_symlinks,cache=yes,kernel_cache,compression=no,reconnect derekh@$PERSONAL_VM_IP:/ /mnt/vm
    else
      sudo sshfs -o allow_other,defer_permissions,transform_symlinks,follow_symlinks,cache=yes,kernel_cache,compression=no,reconnect derekh@$VM_IP:/ /mnt/vm
    fi
  fi
}
function rvm {
  uvm
  mvm
}
function google {
  local search
  # shellcheck disable=SC2145
  echo "Googling: $@"
  for term in "$@"; do
    search="$search%20$term"
  done
  open "https://www.google.com/search?q=$search"
}

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

