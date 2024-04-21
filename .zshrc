# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="awesome-patched"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export PATH=$PATH:/Users/rmmyers/gitscripts/

# Scripts
export PATH=$PATH:~/bin
# Custom scripts for this device
export PATH=$PATH:~/bin.local

# For random things like what's in Haskell stack (for kmonad)
export PATH=$PATH:~/.local/bin

alias zs='source ~/.zshrc'

setopt sh_word_split

# The positiion of this is important as we'd like some GNU tools to be prepended to path.
if [ -f "$HOME/.zshrc.local" ]
then
    source $HOME/.zshrc.local
fi

# aliases
for f in ~/.aliases/*; do source $f; done

# functions
for f in ~/.functions/*; do source $f; done

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Git scripts
export PATH="$PATH:$HOME/src/config/git"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# SDK MAN - claims it has to be at the end, unclear if that's actually true
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# fzf auto-completion
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

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"
