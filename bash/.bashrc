# All functions are in ~/.bash_functions for modularity
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# All Aliases are in ~/.bash_aliases for modularity
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history.
HISTCONTROL==ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

shopt -s expand_aliases

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Heavily inspired by @mathiasbynens's prompt: https://github.com/mathiasbynens/dotfiles
reset="\e[0m";
black="\e[1;30m";
blue="\e[1;34m";
cyan="\e[1;36m";
green="\e[1;32m";
purple="\e[1;35m";
red="\e[1;31m";
white="\e[1;37m";
yellow="\e[1;33m";

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${yellow}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${red}";
else
	hostStyle="${blue}";
fi;

# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]"; # working directory base name
PS1+="\n"; # newline
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${white}\] at ";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\w"; # working directory full path
PS1+="\n";
PS1+="\[${white}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;
