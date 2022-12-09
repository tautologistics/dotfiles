# chezmoi dotfiles

## Setup

### Download setup file

```bash
curl https://raw.githubusercontent.com/tautologistics/dotfiles/main/dot_setup.local > ~/.setup.local
```

### Run the setup file

```bash
. ~/.setup.local
```

## Maintenance

### Find installed apps that can be installed as casks

```bash
brew search --casks '' \
|xargs brew info --cask --json=v2 \
|jq -r --argjson l "$(ls /Applications|\grep '\.app$'|jq -Rsc 'split("\n")[:-1]|map({(.):1})|add')" '.[]|.[]|(.artifacts|map(.[]?|select(type=="string")|select(in($l)))|first) as $a|select($a)|"\(.token): \($a)"'
```
