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

alias gr="git rev-parse --show-toplevel"

setopt sh_word_split

# The positiion of this is important as we'd like some GNU tools to be prepended to path.
if [ -f "$HOME/.zshrc.local" ]
then
    source $HOME/.zshrc.local
fi

# aliases
for f in ~/.aliases/*; do source $f; done

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

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

alias gg="git grep -n"

