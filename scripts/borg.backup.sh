#!/bin/bash

SERVER="server.lan"
if [ -z ${1+x} ]; then HOSTNAME="$(hostname)"; else HOSTNAME="$1"; fi #workaround for android which doesn't use regular hostnames
REPOSITORY="daniel@${SERVER}:/mnt/hdd/borg/${HOSTNAME}"

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
    case $HOSTNAME in
        zenbook425)
            local dirs="/home/daniel /etc /usr/local /root"
            local ignore="--exclude sh:**/*[Cc]ache*/** \
                          --exclude sh:**/baloo/** \
                          --exclude sh:**/.local/share/Trash/**"
            ;;
        oneplus7pro)
            local dirs="/data/data/com.termux/files/home /storage/emulated/0"
            local ignore="--exclude sh:**/0/Android/** \
                          --exclude sh:**/.Ota/** \
                          --exclude sh:**/.thumbnails/** \
                          --exclude sh:**/.oprecyclebin/** \
                          --exclude re:OnePlus7ProOxygen_.*\.zip$"
            ;;
        *)
            echo "Unknown hostname."
            exit 1
            ;;
    esac
    isDestinationUp                         || { message "Backup of ${dirs} on ${HOSTNAME} was unsuccessful! Could not connect to ${SERVER}.";  exit 1; }
    carryOutBackup "${dirs}" "${ignore}"    || { message "Backup of ${dirs} on ${HOSTNAME} was unsuccessful! Error during backup.";             exit 1; }
    carryOutPrune                           || { message "Pruning of repository ${HOSTNAME} was unsuccessful.";                                 exit 1; }
}

main
