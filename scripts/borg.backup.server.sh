#!/bin/bash

BACKUPS_DIR="/mnt/hdd/borg"
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

function message {
    curl -X POST \
        -F "content=$1" \
        -F "username=Bash Scripts" \
        "$(cat ""${DIR}"/../secrets/discord")"
}

function checkLastBackups {
    for d in "$BACKUPS_DIR/*/" ; do # all dirs in dir
        # this is not perfect but it's the best solution I've come up with that doesn't require passphrases for every repository
        LAST_MTIME=$(find "$d" -type f -exec stat \{} --printf="%y\n" \; | sort -n -r | head -n 1)
        DAYS_SINCE=$(( ($(date +%s -d 'now') - $(date +%s -d "$LAST_MTIME")) / 86400))
        if (( DAYS_SINCE > 7 )); then
            message "$(basename $d) was not backed up in the last 7 days!";
        fi
    done
}

function offsiteBackup {
    #TODO rclone -v sync "$d" b2:borg
}

checkLastBackups
offsiteBackup
