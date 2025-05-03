# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

## full history hack
unset HISTFILESIZE
HISTSIZE=10000000
PROMPT_COMMAND="history -a"
export HISTSIZE PROMPT_COMMAND
shopt -s histappend

## check the window size after each command and, if necessary,
## update the values of LINES and COLUMNS.
shopt -s checkwinsize

## make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

## Comment in the above and uncomment this below for a color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;34m\]xilinx\[\033[00;32m\]<\[\033[01;32m\]\t\[\033[00;32m\]>::\[\033[01;32m\]\u\[\033[00;32m\]("\[\033[01;32m\]\w/\[\033[00;32m\]");\e[0m\n\$ '

## If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

## Alias definitions.
## You may want to put all your additions into a separate file like
## ~/.bash_aliases, instead of adding them here directly.
## See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

## enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
fi

## some more ls aliases
alias ll='ls -l'
alias la='ls -al'
alias l='ls -CF'

## Some more alias to avoid making mistakes:
#alias rm='rm -fv'
#alias cp='cp -v'
#alias mv='mv -v'
#alias du='du -h'
#alias df='df -h'
alias diff='colordiff'
alias top='htop'
#alias emacs='emacs21 -nw'

## windows aliases
alias cd..='cd ..'

## grep colors
alias grep='grep --color'

## enable programmable completion features (you don't need to enable
## this, if it's already enabled in /etc/bash.bashrc and /etc/profile
## sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

## append /sbin for ifconfig
if [[ -z "$(echo ${PATH} | grep '/sbin')" ]]; then
    export PATH=${PATH}:/sbin
fi

## append /usr/sbin for arp
if [[ -z "$(echo ${PATH} | grep '/usr/sbin')" ]]; then
    export PATH=${PATH}:/usr/sbin
fi

## xilinx setup
export EN_SYS_ENV="/home/${USER}/.petalinux-sys.env"
source "${EN_SYS_ENV}"

## xilinx environment
test -f "/home/${USER}/workspace/settings.sh" && source "/home/${USER}/workspace/settings.sh"
source "/tools/Xilinx/Vivado/2024.2/settings64.sh"

echo "setting environment"
echo "PATH=${PATH}"
echo
