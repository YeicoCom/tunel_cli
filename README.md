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

bin/tunel help # show usage
bin/tunel update # self update asdf package

bin/tunel sessions
bin/tunel login <email>
bin/tunel logout <email>
bin/tunel list_servers
bin/tunel list_shares <server_id>
bin/tunel add_server
#use @ for empty name/network
bin/tunel update_server <server_id> <name> <network>
bin/tunel delete_server <server_id> <host_uuid>
bin/tunel start_server
bin/tunel stop_server
bin/tunel share_server <server_id> <user_email>
bin/tunel unshare_server <share_id>
```
