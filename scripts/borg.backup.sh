#!/bin/bash

SERVER="server.lan"
REPOSITORY="daniel@${SERVER}:/mnt/hdd/borg/$(hostname)"

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
PASSPHRASE="$(cat ""${DIR}"/../secrets/borg")"
export BORG_PASSPHRASE="$PASSPHRASE"

function message {
    curl -X POST \
        -F "content=$1" \
        -F "username=Bash Scripts" \
        "$(cat ""${DIR}"/../secrets/discord")"
}

function carryOutPrune {
    borg prune -v --list "$REPOSITORY" --prefix "auto" --keep-daily=7 --keep-weekly=3 --keep-monthly=-1
}

function carryOutBackup {
    borg create -v --stats "${REPOSITORY}::auto-{now:%Y-%m-%d %H:%M}" $1 $2
}

function isDestinationUp {
    ping -c 1 -W 2 "$SERVER" &> /dev/null
}

function main {
    case $(hostname) in
        zenbook425)
            local dirs="/home/daniel /etc /usr/local /root"
            local ignore="--exclude '*/[Cc]ache/*' \
                          --exclude '*/.[Cc]ache/*' \
                          --exclude '*/baloo/*' \
                          --exclude '*/.local/share/Trash'"
            ;;
        todo)
            local dirs="todo"
            local ignore=""
            ;;
        *)
            echo "Unknown hostname."
            exit 1
            ;;
    esac
    isDestinationUp                         || { message "Backup of ${dirs} on $(hostname) was unsuccessful! Could not connect to ${SERVER}.";  exit 1; }
    carryOutBackup "${dirs}" "${ignore}"    || { message "Backup of ${dirs} on $(hostname) was unsuccessful! Error during backup.";             exit 1; }
    carryOutPrune                           || { message "Pruning of repository $(hostname) was unsuccessful.";                                 exit 1; }
}

main
