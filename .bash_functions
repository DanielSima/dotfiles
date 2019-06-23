#don't forget to restart terminal after changes - source .bashrc

#init and add remote for current directory
function gir() {

    git init && git remote add origin $1
  
}

#commit and push current directory
function gcp() {

    git add . && git commit -am "$1" && git push -u origin master

}

#move file and symlink it back, useful for putting dotfiles into git directory
function msl() { 

    mv "$1" "$2" && ln -s "$2" "$1"

}
