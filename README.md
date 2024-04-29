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
bin/tunel list_severs
bin/tunel list_shares <server_id>

```
