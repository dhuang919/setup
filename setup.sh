#!/bin/bash
set -eo pipefail


function install_ansible {
  echo "Installing ansible..."
  sudo pip3 install ansible
  echo
}

function ansible_playbook {
  echo "Running ansible-playbook..."
  cd ~/dev/setup/ansible
  ansible-playbook ./playbooks/macos.yml
  echo
}

function main {
  install_ansible
  ansible_playbook
}

main
