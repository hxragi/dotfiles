#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman='sudo pacman'
PS1='[\u@\h \W]\$ '

export JAVA_HOME=$HOME/.jdks/jdk-21.0.10+7
export PATH=$JAVA_HOME/bin:$PATH
. "$HOME/.cargo/env"

. "$HOME/.local/bin/env"
