#!/bin/bash
set -eo pipefail


function install_pip {
  echo "Installing pip..."
  sudo easy_install pip
  echo
}

function install_ansible {
  echo "Installing ansible..."
  sudo pip install ansible
  echo
}

function ansible_playbook {
  echo "Running ansible-playbook..."
  cd ~/dev/setup/ansible
  ansible-playbook ./playbooks/macos.yml
  echo
}

function main {
  install_pip
  install_ansible
  ansible_playbook
}

main
