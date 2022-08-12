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
