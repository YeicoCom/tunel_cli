# Tunel CLI

- panic won't bubble to top level from subshell
- macos service requires to prefix service PATH with /opt/homebrew/bin
- api failures still show ugly stack trace instead of simple panic message
- wg-quick down always fails from macos shell and leaves /var/run/x_tmx.conf behind, path mismatch?

## Dev Setup

- set dash.tunel.mx to localhost in builder:/etc/hosts
- sudo ssh -i /Users/samuel/.ssh/id_ed25519 samuel@builder.quick -L 5002:localhost:5002 -L 443:localhost:443
- set 127.0.0.1 dash.tunel.mx in mbair:/etc/hosts

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

tunel help # show usage
tunel update # self update asdf packages
```
