#cheat.sh
function cheat() { 

    curl cheat.sh/"$1"

}

#history (use !number)
function hs() { 

    history | grep --color=always $1

}

#better ls
function lss() { 

    ls --color --classify --group-directories-first --human-readable --almost-all $1

}

