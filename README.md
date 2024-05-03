# Tunel CLI

- in builder set dash.tunel.mx to localhost in /etc/hosts
- for mbair login access code is retrieved over ssh

```bash
asdf plugin add tunel_cli https://github.com/YeicoCom/tunel_asdf.git
asdf list all tunel_cli
asdf install tunel_cli main
asdf install tunel_cli <commit-or-tag-or-release>
asdf uninstall tunel_cli main
asdf uninstall tunel_cli <commit-or-tag-or-release>
asdf global tunel_cli main
asdf global tunel_cli <commit-or-tag-or-release>
asdf local tunel_cli main
asdf local tunel_cli <commit-or-tag-or-release>
asdf plugin remove tunel_cli

#brew install fswatch nano git wireguard-tools unzip curl
#sudo apt install net-tools nano sudo build-essential git wireguard-tools unzip curl inotify-tools uuid-runtime
#git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
#echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
#. "$HOME/.asdf/asdf.sh"
asdf plugin add tunel_cli https://github.com/YeicoCom/tunel_asdf.git
asdf install tunel_cli main
asdf global tunel_cli main

bin/tunel help # show usage
bin/tunel update # self update asdf packages
```
