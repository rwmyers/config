#################### Platform settings ############################
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == "Linux" ]]; then
    platform='linux'
elif [[ "$unamestr" == CYGWIN* ]]; then
    platform='cygwin'
fi

#################### Misc settings ################################
# case-insensitive tab completion
set completion-ignore-case on

#################### History settings #############################
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#################### Window settings ##############################
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#################### Prompt settings ##############################
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Git branch parsing
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
 
function proml {
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local      YELLOW="\[\033[0;33m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local LIGHT_PURPLE="\[\033[1;34m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac
 
PS1="${TITLEBAR}\
$LIGHT_PURPLE\w$YELLOW\$(parse_git_branch)\
\n$LIGHT_GRAY\$ "
PS2='> '
PS4='+ '
}
proml

#################### Aliases settings ##############################
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

alias g='git'


#################### Functions ####################################
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

#################### Cygwin-specific settings #####################
if [[ $platform == 'cygwin' ]]; then
    # unset TMP and TEMP in Cygwin as Windows environment variables
    # are case insensitive.
    unset TMP
    unset TEMP

    # gvim path
    PATH=$PATH:/cygdrive/c/vim
fi

#################### Perforce settings ############################
P4CONFIG=.p4config
export P4CONFIG
PATH=$PATH:/home/mezner/p4
PATH=$PATH:/cygdrive/c/vim/vim73

#################### FINAL settings ###############################
export PATH


