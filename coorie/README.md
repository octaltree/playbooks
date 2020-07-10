# coorieの構成管理
ansible動作環境が必要
$ ansible-galaxy install -r requirements.yml --force
$ ansible-playbook play.yml

## TODO
* zplugin update --all
* ~/.tmux/plugins/tpm/bin/install_plugins
  - Installing
  - donwload success
  - Already installed
* ~/.tmux/plugins/tpm/bin/update_plugins all
  - update success
* nvim -c ":call dein#install()" -c ":q"
* nvim -c ":call dein#update()" -c ":q"
* nvim -c ":UpdateRemotePlugins" -c ":q"
