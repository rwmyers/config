
export EDITOR=nvim
# Keep emacs mode for zsh (prevents Home/End keys from entering vi mode and capitalizing text)
bindkey -e
export HISTSIZE=10000
export SAVEHIST=12000
export HISTFILE="$HOME/.cache/zsh/history"

if [ ! -d $(dirname $HISTFILE) ]; then
    echo "$(dirname $HISTFILE)/ directory does not exist. Creating it now."
    mkdir -p $(dirname $HISTFILE)
fi

# Source zsh config files
for f in ~/.config/zsh/*; do source $f; done

# Nix: put ~/.nix-profile/bin on PATH (kept here, not /etc, so it's portable).
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# Nix profile root — reused when sourcing share/ files from Nix packages.
NIX_PROFILE="$HOME/.nix-profile"

# Scripts
export PATH=$PATH:~/bin
# Custom scripts for this device
export PATH=$PATH:~/bin.local
# Git helper scripts; only present on some machines
export PATH=$PATH:~/gitscripts

# Go binaries
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin

# For random things like what's in Haskell stack (for kmonad)
export PATH=$PATH:~/.local/bin

# Reload config with a fresh shell (re-sourcing double-wraps ZLE plugins like
# zsh-syntax-highlighting, which floods warnings). exec keeps cwd + env.
alias zs='exec zsh'

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

# Rust
export PATH="$HOME/.cargo/bin:$HOME/.cargo/env:$PATH"

if [[ "$OSTYPE" == "darwin"* ]];
then
    # Add Visual Studio Code (code)
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# GIT
export CONFIG_GIT="$HOME/src/config/git"
## Scripts
export PATH="$PATH:$CONFIG_GIT"

# ---- Completions ----
# fpath (Function Path) is a Zsh array that tells the shell where to look for 
# completion definitions (files starting with '_') and other autoloadable functions.
# Directories added to fpath must be set BEFORE calling 'compinit'.
fpath=($HOME/.completions $CONFIG_GIT/completion $HOME/.local/completions $fpath)

autoload -U compinit; compinit

# SDK MAN - claims it has to be at the end, unclear if that's actually true
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ---- fzf (command-line fuzzy find) ----
command -v fzf > /dev/null && source <(fzf --zsh)

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
[ -f "$NIX_PROFILE/share/fzf-git-sh/fzf-git.sh" ] && source "$NIX_PROFILE/share/fzf-git-sh/fzf-git.sh"

# ---- Zoxide (better cd) (https://github.com/ajeetdsouza/zoxide)
eval "$(zoxide init zsh --cmd cd)"

# ---- Starship (https://starship.rs/)
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# ---- Snap installs ----
export PATH="$PATH:/snap/bin"

# ---- Clippy (https://github.com/nedn/clippy) ----
export PATH="$PATH:$HOME/src/clippy"

# ---- fzf zsh tab competion (https://github.com/Aloxaf/fzf-tab)
[ -f "$NIX_PROFILE/share/fzf-tab/fzf-tab.plugin.zsh" ] && source "$NIX_PROFILE/share/fzf-tab/fzf-tab.plugin.zsh"

# ---- zsh autosuggestions (https://github.com/zsh-users/zsh-autosuggestions) ----
[ -f "$NIX_PROFILE/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$NIX_PROFILE/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Accept the current suggestion with Ctrl+Space.
bindkey '^ ' autosuggest-accept

# Local
if [ -f "$HOME/.zshrc.local" ]
then
    source $HOME/.zshrc.local
fi

# ---- zsh syntax highlighting (https://github.com/zsh-users/zsh-syntax-highlighting) ----
# Must be sourced last, after everything else that touches ZLE.
[ -f "$NIX_PROFILE/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$NIX_PROFILE/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

