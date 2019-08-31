#!/bin/bash
set -eo pipefail

SETUP_DIR="$HOME/dev/setup"

mkdir -p "$SETUP_DIR"

install_clt() {
    if xcode-select -p &> /dev/null != 0; then
        echo "Installing Command Line Tools..."
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        PROD=$(
            softwareupdate -l |
            grep -B 1 -E 'Command Line Tools' |
            awk -F'*' '/^ +\*/ {print $2}' |
            sed 's/^ *//' |
            grep -iE '[0-9|.]' |
            sort |
            tail -n1
        )
        softwareupdate -i "$PROD" -v
    else
        echo "Command Line Tools already installed"
    fi
    echo
}

clone_setup_repo() {
    git clone https://github.com/dhuang919/setup.git "$SETUP_DIR"
}

install_pip() {
    if command -v pip &> /dev/null != 0; then
        echo "Installing pip..."
        sudo easy_install pip
    else
        echo "pip already installed"
    fi
    echo
}

install_ansible() {
    if command -v ansible &> /dev/null != 0; then
        echo "Installing ansible..."
        sudo pip install ansible
    else
        echo "Ansible already installed"
    fi
    echo
}

ansible_playbook() {
    echo "Running ansible-playbook..."
    cd "$SETUP_DIR/ansible"
    ansible-playbook ./playbooks/macos.yml
}

main() {
    install_clt
    clone_setup_repo
    install_pip
    install_ansible
    ansible_playbook
}

main
