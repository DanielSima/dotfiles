#!/bin/bash

# USAGE
# $1
#   == setup, creates timer
#   == anything else, runs backup and prune
# $2
#   overwrites hostname variable

SERVER="server.lan"
if [ -z ${2+x} ]; then HOSTNAME="$(hostname)"; else HOSTNAME="$2"; fi #workaround for android which doesn't use regular hostnames
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

function setUp {
        case $HOSTNAME in
        server)
            cat > /etc/systemd/system/borg.backup.service <<- EOM
			[Unit]
			Description=Borg Backup
			Wants=borg.backup.timer

			[Service]
			Type=simple
			Nice=19
			CPUSchedulingPriority=50
			IOSchedulingPriority=3
			ExecStart=/home/daniel/dotfiles/scripts/borg.backup.sh
			User=root
			EOM
            cat > /etc/systemd/system/borg.backup.timer <<- EOM
			[Unit]
			Description=Borg Backup Timer
			Requires=borg.backup.timer

			[Timer]
			Unit=borg.backup.service
			# every day at 2am
			OnCalendar=*-*-* 2:00:00

			[Install]
			WantedBy=timers.target
			EOM
            systemctl daemon-reload
            systemctl enable borg.backup.timer
            systemctl start borg.backup.timer
        ;;
        zenbook425)
            cat > /etc/systemd/system/borg.backup.service <<- EOM
			[Unit]
			Description=Borg Backup
			Wants=borg.backup.timer

			[Service]
			Type=simple
			Nice=19
			CPUSchedulingPriority=50
			IOSchedulingPriority=3
			ExecStart=/home/daniel/dotfiles/scripts/borg.backup.sh
			User=root
			EOM
            cat > /etc/systemd/system/borg.backup.timer <<- EOM
			[Unit]
			Description=Borg Backup Timer
			Requires=borg.backup.timer

			[Timer]
			Unit=borg.backup.service
			# 1 hour after boot, then every 4 hours
			OnBootSec=1hours
			OnUnitActiveSec=4hours

			[Install]
			WantedBy=timers.target
			EOM
            systemctl daemon-reload
            systemctl enable borg.backup.timer
            systemctl start borg.backup.timer
        ;;
        oneplus7pro)
            # every day at 21:00
            # OVERWRITES CORNTAB !
            echo "0 21 * * * bash ${DIR}/borg.backup.sh main oneplus7pro" | crontab -
            ;;
        *)
            echo "Unknown hostname."
            exit 1
            ;;
    esac
}

function beforeBackup {
    case $HOSTNAME in
        server)
            docker stop plex radarr sonarr jackett qbittorrent tautulli
        ;;
        *)
            return 0
            ;;
    esac
}

function afterBackup {
    case $HOSTNAME in
        server)
            docker start plex radarr sonarr jackett qbittorrent tautulli
        ;;
        *)
            return 0
            ;;
    esac
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
        server)
            local dirs="/home/daniel /etc /usr/local /root /mnt/hdd/photos"
            local ignore="--exclude sh:**/*BORG_IGNORE*/** \
                          --exclude sh:**/*[Cc]ache*/** \
                          --exclude sh:**/transcode/**"
        ;;
        zenbook425)
            local dirs="/home/daniel /etc /usr/local /root"
            local ignore="--exclude sh:**/*BORG_IGNORE*/** \
                          --exclude sh:**/*[Cc]ache*/** \
                          --exclude sh:**/baloo/** \
                          --exclude sh:**/.local/share/Trash/**"
            ;;
        oneplus7pro)
            local dirs="/data/data/com.termux/files/home /storage/emulated/0"
            local ignore="--exclude sh:**/*BORG_IGNORE*/** \
                          --exclude sh:**/0/Android/** \
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
    isDestinationUp                         || { message "Backup of ${dirs} on ${HOSTNAME} was unsuccessful! Could not connect to ${SERVER}.";               exit 1; }
    beforeBackup
    carryOutBackup "${dirs}" "${ignore}"    || { message "Backup of ${dirs} on ${HOSTNAME} was unsuccessful! Error during backup.";             afterBackup; exit 1; }
    carryOutPrune                           || { message "Pruning of repository ${HOSTNAME} was unsuccessful.";                                 afterBackup; exit 1; }
    afterBackup
}

if [ "$1" = "setup" ]; then
    setUp
else
    main
fi
