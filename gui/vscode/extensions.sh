#!/bin/bash

EXTENSIONS=(alefragnani.Bookmarks
alefragnani.project-manager
christian-kohler.path-intellisense
coolbear.systemd-unit-file
cschlosser.doxdocgen
eamodio.gitlens
Equinusocio.vsc-community-material-theme
Equinusocio.vsc-material-theme
equinusocio.vsc-material-theme-icons
fabiospampinato.vscode-diff
GrapeCity.gc-excelviewer
Gruntfuggly.todo-tree
James-Yu.latex-workshop
mads-hartmann.bash-ide-vscode
ms-python.python
ms-python.vscode-pylance
ms-toolsai.jupyter
ms-toolsai.jupyter-keymap
ms-toolsai.jupyter-renderers
ms-vscode.cpptools
naumovs.color-highlight
njpwerner.autodocstring
redhat.vscode-yaml
rogalmic.bash-debug
shakram02.bash-beautify
shardulm94.trailing-spaces
streetsidesoftware.code-spell-checker
streetsidesoftware.code-spell-checker-czech
sumneko.lua)

for ((i = 0; i < ${#EXTENSIONS[@]}; i++))
do
    code --install-extension "${EXTENSIONS[$i]}"
done
