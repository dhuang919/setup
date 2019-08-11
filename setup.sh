#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# fill in /ansible/roles/darwin_bootstrap/vars/main.yml before running

### set system preferences

set_host() {
    echo "Setting host names..."
    local HOSTNAME='derek'
    sudo scutil --set ComputerName $HOSTNAME
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $HOSTNAME
}

set_system_preferences() {
    echo "Setting system preferences..."

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

copy_fonts() {
    echo "Copying fonts..."
    sudo cp fonts/*.otf ~/Library/Fonts
}

symlink_and_source_dotfiles() {
    cd ./dotfiles
    # shellcheck disable=SC2010,SC2207
    local my_dotfiles=($(ls -d .[a-zA-Z]* | grep -v .gitignore))

    echo "Symlinking following dotfiles to HOME:"
    echo "${my_dotfiles[@]}"
    echo

    for dotfile in "${my_dotfiles[@]}"; do
        if ! [[ -L "${HOME}/${dotfile}" ]]; then
            echo "  > symlinking $(pwd)/${dotfile} to ${HOME}/${dotfile}"
            ln -fns "$(pwd)/dotfiles/${dotfile}" "${HOME}/${dotfile}"
        else
            echo "  > symlink for ${dotfile} already exists"
        fi
    done

    # shellcheck disable=SC1090
    source "$HOME/.zshrc"
    cd -
}

### install stuff

install_pip() {
    if test ! "$(command -v pip &>/dev/null)"; then
        echo "Installing pip..."
        cd /tmp || exit
        curl 'https://bootstrap.pypa.io/get-pip.py' -o get-pip.py
        python get-pip.py
        cd -
    else
        echo "pip already installed"
    fi
}

install_ansible() {
    if test ! "$(command -v ansible &>/dev/null)"; then
        echo "Installing ansible..."
        sudo pip install ansible
    else
        echo "Ansible already installed"
    fi
}

install_homebrew() {
    if test ! "$(command -v brew &>/dev/null)"; then
        echo "Installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 2>&1
    else
        echo "Homebrew already installed"
    fi
}

install_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

install_xcode() {
    if ! [[ -d /Library/Developer/CommandLineTools/Library/ ]]; then
        echo "Installing Xcode..."
        xcode-select --install
        while [ ! -d /Library/Developer/CommandLineTools/Library/ ]; do
            sleep 2
        done
    else
        echo "Xcode already installed"
    fi
}

### install more stuff

run_ansible() {
    echo "Running ansible..."
    cd "${HOME}/dev/setup/ansible"
    ansible-playbook ./playbooks/darwin_bootstrap.yml -v
    cd -
}

install_node_8() {
    if ! test "$(command -v nvm &>/dev/null)"; then
        echo "No nvm command exists"
    elif ! [[ "$(command -v node)" = *"v8.10.0"* ]]; then
        echo "Installing node 8.10.0..."
        nvm install v8.10.0
        nvm alias default 8.10.0
    else
        echo "Node 8.10.0 already installed"
    fi
}

setup_npm() {
    if ! test "$(command -v npm &>/dev/null)"; then
        echo "No npm command exists"
    else
        echo "Setting npm configs, upgrading npm, and installing diff-so-fancy..."
        npm set progress=false
        npm set package-lock=false
    fi
}

# TODO: uninstall unwanted OS X apps

main() {
    # install stuff
    install_xcode
    install_pip
    install_ansible
    install_homebrew
    install_ohmyzsh

    # set system preferences
    symlink_and_source_dotfiles
    set_host
    set_system_preferences
    copy_fonts

    # install more stuff
    run_ansible
    install_node_8
    setup_npm
}

main
