
export HISTSIZE=10000
export SAVEHIST=12000
export HISTFILE="$HOME/.cache/zsh/history"

if [ ! -d $(dirname $HISTFILE) ]; then
    echo "$(dirname $HISTFILE)/ directory does not exist. Creating it now."
    mkdir -p $(dirname $HISTFILE)
fi

# Source zsh config files
for f in ~/.config/zsh/*; do source $f; done

export PATH=$PATH:/Users/rmmyers/gitscripts/

# Scripts
export PATH=$PATH:~/bin
# Custom scripts for this device
export PATH=$PATH:~/bin.local

# For random things like what's in Haskell stack (for kmonad)
export PATH=$PATH:~/.local/bin

alias zs='source ~/.zshrc'

setopt sh_word_split

# ---- Aliases ----
# General
for f in ~/.aliases/*; do source $f; done
# Local
for f in ~/.aliases.local/*(N); do
    source $f
done

if [ -d "$HOME/.local/aliases/" ]
then
    for f in ~/.local/aliases/*; do
        source $f
    done
fi

# ---- Functions----
# General. Recursively match all sub-directories and files
for f in ~/.functions/**/*(.); do source $f; done
# Local
for f in ~/.functions.local/*(N); do
    source $f
done

if [ -d "$HOME/.local/functions/" ]
then
    for f in ~/.local/functions/*; do
        source $f
    done
fi

# ---- Completions ----
# General. Recursively match all sub-directories and files
for f in ~/.completions/**/*(.); do source $f; done

# Local
if [ -d "$HOME/.local/completions/" ]
then
    for f in ~/.local/completions/**/*(.); do
        source $f
    done
fi

# Rust
export PATH="$HOME/.cargo/bin:$HOME/.cargo/env:$PATH"

if [[ "$OSTYPE" == "darwin"* ]];
then
    # GNU tools
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

    # Add Visual Studio Code (code)
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# GIT
export CONFIG_GIT="$HOME/src/config/git"
## Scripts
export PATH="$PATH:$CONFIG_GIT"

## Completions
for c in $CONFIG_GIT/completion/*; do source $c; done

# NVIM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# SDK MAN - claims it has to be at the end, unclear if that's actually true
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ---- fzf (command-line fuzzy find) ----
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# -- fzf-git (https://github.com/junegunn/fzf-git.sh) --
source ~/src/fzf-git.sh/fzf-git.sh

# ---- Zoxide (better cd) (https://github.com/ajeetdsouza/zoxide)
eval "$(zoxide init zsh --cmd cd)"

# ---- Starship (https://starship.rs/)
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# ---- Snap installs ----
export PATH="$PATH:/snap/bin"

# ---- fzf zsh tab competion (https://github.com/Aloxaf/fzf-tab)
autoload -U compinit; compinit
source ~/src/fzf-tab/fzf-tab.plugin.zsh

if [ -f "$HOME/.zshrc.local" ]
then
    source $HOME/.zshrc.local
fi
