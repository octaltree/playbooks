#!/bin/sh

cd ~/storage/opt/playbooks/coorie
#cd ~/.local/playbooks/coorie
ansible-playbook play.yml $*
