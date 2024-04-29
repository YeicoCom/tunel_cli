# Tunel CLI

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

asdf plugin add tunel_cli https://github.com/YeicoCom/tunel_asdf.git
asdf install tunel_cli main
asdf global tunel_cli main

bin/tunel help # show usage
bin/tunel update # self update asdf package

bin/tunel setup
bin/tunel login <email>
bin/tunel logout
bin/tunel list_servers
bin/tunel add_server
#use @ for empty name/network
bin/tunel update_server <name> <network>
bin/tunel delete_server
bin/tunel status_server
bin/tunel restart_server
bin/tunel add_client <server_id>
bin/tunel delete_client
bin/tunel status_client
bin/tunel restart_client
```
