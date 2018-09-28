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
  local HOSTNAME='derekhuang'
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

  echo "  -> setting Cobalt2 as default iTerm theme"
  open "$HOME/Desktop/keybase/osx-setup/assets/Cobalt2.itermcolors"
  sleep 1  # Wait a bit to make sure the theme is loaded
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false

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

function set_wallpaper {
  local THIRTEEN
  local FIFTEEN
  local RESOLUTION

  echo "Setting wallpaper"
  RESOLUTION=$(system_profiler SPDisplaysDataType | grep Resolution)
  if [[ $RESOLUTION = *"2560 x 1600"* ]]; then
    echo "  > setting thirteen.jpg as background"
    THIRTEEN="$HOME/Desktop/osx-setup/assets/thirteen.jpg"
    sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$THIRTEEN'"  # TODO not working - quotes around path necessary?
    killall Dock
  elif [[ $RESOLUTION = *"2880 x 1800"* ]]; then
    echo "  > setting fifteen.jpg as background"
    FIFTEEN="$HOME/Desktop/osx-setup/assets/fifteen.jpg"
    sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$FIFTEEN'"  # TODO not working - quotes around path necessary?
    killall Dock
  else
    echo "Resolution not found - not setting wallpaper"
  fi
}

function copy_fonts {
  echo "Copying files"
  sudo cp fonts/*.otf ~/Library/Fonts
}

function symlink_and_source_dotfiles {
  # local my_dotfiles="$(ls -d .[^.*]* | grep -v '.git\b\|.gitignore\b')"
  local my_dotfiles
  local dotfile
  local PWD

  echo "Symlinking following dotfiles to HOME:"
  my_dotfiles=(".bash_profile" ".bash_private" ".gitconfig" ".git-completion.bash" ".git-prompt.sh")
  echo "${my_dotfiles[@]}"

  for dotfile in "${my_dotfiles[@]}"; do
    if ! [[ -L "${HOME}/${dotfile}" ]]; then
      PWD=$(pwd)
      echo "  > symlinking ${PWD}/dotfiles/${dotfile} to ${HOME}/${dotfile}"
      ln -fns "${PWD}/dotfiles/${dotfile}" "${HOME}/${dotfile}"
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
    sudo easy_install pip
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
  pushd "${HOME}/Desktop/osx-setup/ansible" &>/dev/null
    ansible-playbook ./playbooks/darwin_bootstrap.yml -v
  popd
}

function install_vscode_settings_sync {
  if ! test "$(command -v code)"; then
    echo "No code command exists"
  else
    echo "Installing VSCode Settings Sync"
    code --install-extension Shan.code-settings-sync
  fi
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
