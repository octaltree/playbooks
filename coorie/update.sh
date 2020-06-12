#!/bin/sh

cd ~/storage/opt/playbooks/coorie
#cd ~/.local/playbooks/coorie
ansible-galaxy install -r requirements.yml --force
ansible-playbook play.yml $*
