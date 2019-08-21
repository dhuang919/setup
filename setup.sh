#!/bin/bash
set -euo pipefail

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

install_pip() {
    if test ! "$(command -v pip &>/dev/null)"; then
        echo "Installing pip..."
        sudo easy_install pip
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

run_ansible() {
    echo "Running ansible..."
    cd "${HOME}/dev/setup/ansible"
    ansible-playbook ./playbooks/darwin_bootstrap.yml -v
    cd -
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

main() {
    install_xcode
    install_pip
    install_ansible
    run_ansible
}

main
