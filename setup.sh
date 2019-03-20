#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Things to do before running:
  # 1. xcode-select --install
  # 2. Fill in /ansible/.../vars/main.yml

##############################################
# System Preferences
##############################################

function set_host {
  echo "Setting host names"
  local HOSTNAME='derek'
  sudo scutil --set ComputerName $HOSTNAME
  sudo scutil --set HostName $HOSTNAME
  sudo scutil --set LocalHostName $HOSTNAME
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $HOSTNAME
}

function set_system_preferences {
  echo "Setting system preferences"

  echo "  -> toggling autohide"
  defaults write com.apple.dock autohide -bool true

  echo "  -> removing autohide delay"
  defaults write com.apple.dock autohide-delay -float 0

  echo "  -> turning launch animation off"
  defaults write com.apple.dock launchanim -bool false

  echo "  -> shrinking tile size"
  defaults write com.apple.dock tilesize -int 40

  echo "  -> app minimize effect"
  defaults write com.apple.dock mineffect -string "scale"

  echo "  -> keep spaces intact"
  defaults write com.apple.dock mru-spaces -bool false

  echo "Mail settings"

  echo "  -> disable send and reply animations"
  defaults write com.apple.mail DisableReplyAnimations -bool true
  defaults write com.apple.mail DisableSendAnimations -bool true

  echo "  -> copy emails as address only (no names)"
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

  echo "  -> disable Mail inline attachment viewing"
  defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

  echo "General settings"

  echo "  -> disable check spelling as you type"
  defaults write -g CheckSpellingWhileTyping -bool false
  defaults write -g WebContinuousSpellCheckingEnabled -bool false

  echo "  -> disable auto-correct"
  defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

  echo "  -> disable auto-capitalization"
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

  echo "  -> disable smart dashes and smart quotes"
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  echo "  -> disable automatic period substitution"
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

  echo "  -> prevent Photos from opening automatically"
  defaults write com.apple.ImageCapture disableHotPlug -bool true

  echo "  -> sleep after 15 min of inactivity"
  sudo pmset displaysleep 15

  echo "  -> restart automatically if the computer freezes"
  sudo systemsetup -setrestartfreeze on

  echo "  -> setting dark mode for menu bar and dock"
  osascript <<EOD
    tell application "System Events"
      tell appearance preferences
        set dark mode to true
      end tell
    end tell
EOD
}

function copy_fonts {
  echo "Copying Fonts"
  sudo cp fonts/*.otf ~/Library/Fonts
}

function symlink_and_source_dotfiles {
  local my_dotfiles="$(ls -d .[^.*]* | grep -v '.DS_Store\b')"
  local dotfile

  echo "Symlinking following dotfiles to HOME:"
  echo "${my_dotfiles[@]}"

  for dotfile in "${my_dotfiles[@]}"; do
    if ! [[ -L "${HOME}/${dotfile}" ]]; then
      echo "  > symlinking $(pwd)/dotfiles/${dotfile} to ${HOME}/${dotfile}"
      ln -fns "$(pwd)/dotfiles/${dotfile}" "${HOME}/${dotfile}"
    else
      echo "  > symlink for ${dotfile} already exists"
    fi
  done
  # shellcheck disable=SC1090
  source "$HOME/.bash_profile"
}

##############################################
# Install Software
##############################################

function install_pip {
  if test ! "$(command -v pip)"; then
    echo "Installing pip"
    curl 'https://bootstrap.pypa.io/get-pip.py' -o get-pip.py
    python get-pip.py
    rm get-pip.py
  else
    echo "pip already installed"
  fi
}

function install_ansible {
  if test ! "$(command -v ansible)"; then
    echo "Installing ansible"
    sudo pip install ansible
  else
    echo "Ansible already installed"
  fi
}

function install_homebrew {
  if test ! "$(command -v brew)"; then
    echo "Installing Homebrew"
    # Pipe the implicit newline (return key) that echo generates for Homebrew installation prompt
    echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "Homebrew already installed"
  fi
}

##############################################
# Setup Software
##############################################

function run_ansible {
  echo "Running ansible"
  cd "${HOME}/Desktop/dev/setup/ansible"
  ansible-playbook ./playbooks/darwin_bootstrap.yml -v
  cd -
}

function link_nvm {
  set +u
  if ! [ -d "$HOME/.nvm" ]; then
    echo "$HOME/.nvm does not exist"
  else
    if [ -z ${NVM_DIR+x} ]; then
      echo "Exporting NVM_DIR"
      export NVM_DIR="$HOME/.nvm"
    fi
    if ! test "$(command -v nvm)"; then
      echo "Loading nvm"
      # shellcheck disable=SC1091
      source /usr/local/opt/nvm/nvm.sh
    fi
  fi
  set -u
}

function install_node_8 {
  if ! test "$(command -v nvm)"; then
    echo "No nvm command exists"
  elif ! [[ "$(command -v node)" = *"v8.4.0"* ]]; then
    echo "Installing node 8.4.0"
    nvm install v8.4.0
    nvm alias default 8.4.0
  else
    echo "Node 8.4.0 already installed"
  fi
}

function setup_npm {
  set +u
  if ! test "$(command -v npm)"; then
    echo "No npm command exists"
  else
    echo "Setting npm configs, upgrading npm, and installing diff-so-fancy"
    npm set progress=false
    npm set package-lock=false
    npm i -g npm diff-so-fancy
  fi
  set -u
}

# TODO: uninstall unwanted OS X apps

function main {
  ### System Preferences ###
  set_host
  set_system_preferences
  set_wallpaper
  copy_fonts
  symlink_and_source_dotfiles

  ### Install Software ###
  install_pip
  install_ansible
  install_homebrew

  ### Setup software ###
  run_ansible
  install_vscode_settings_sync
  link_nvm
  install_node_8
  setup_npm
}

main
