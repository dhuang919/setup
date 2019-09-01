#!/bin/bash
set -eo pipefail

SETUP_DIR="$HOME/dev/setup"

mkdir -p "$SETUP_DIR"

install_clt() {
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
  softwareupdate -i "$PROD" --verbose
  echo
}

clone_setup_repo() {
  echo "Cloning setup repo..."
  git clone https://github.com/dhuang919/setup.git "$SETUP_DIR"
  echo
}

install_pip() {
  echo "Installing pip..."
  sudo easy_install pip
  echo
}

install_ansible() {
  echo "Installing ansible..."
  sudo pip install ansible
  echo
}

ansible_playbook() {
  echo "Running ansible-playbook..."
  cd "$SETUP_DIR/ansible"
  ansible-playbook ./playbooks/macos.yml
  echo
}

main() {
  install_clt
  clone_setup_repo
  install_pip
  install_ansible
  ansible_playbook
}

main

