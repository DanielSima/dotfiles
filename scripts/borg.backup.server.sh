#!/bin/bash

# USAGE
# $1
#   == setup, creates timer
#   == anything else, runs backups check and upload to BackBlaze

# NOTE TO FUTURE ME: since backup is done by root, everything needs to be mounted by root also, add 'user_allow_other' to /etc/fuse.conf

BACKUPS_DIR="/mnt/hdd/borg"
DEST_DIR="b2:borg-backup-272"
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

function message {
    curl -X POST \
        -F "content=$1" \
        -F "username=Bash Scripts" \
        "$(cat ""${DIR}"/../secrets/discord")"
}


function setUp {
    cat > /etc/systemd/system/borg.backup.server.service <<- EOM
	[Unit]
	Description=Borg Backup Server
	Wants=borg.backup.server.timer

	[Service]
	Type=simple
	Nice=19
	CPUSchedulingPriority=50
	IOSchedulingPriority=3
	ExecStart=/home/daniel/dotfiles/scripts/borg.backup.server.sh
	User=daniel
	EOM
	cat > /etc/systemd/system/borg.backup.server.timer <<- EOM
	[Unit]
	Description=Borg Backup Server Timer
	Requires=borg.backup.server.timer

	[Timer]
	Unit=borg.backup.server.service
	# every day at 2:30am
	OnCalendar=*-*-* 2:30:00

	[Install]
	WantedBy=timers.target
	EOM
    systemctl daemon-reload
    systemctl enable borg.backup.server.timer
    systemctl start borg.backup.server.timer
}

function checkLastBackups {
    for d in "$BACKUPS_DIR"/*/ ; do # all dirs in dir
        # this is not perfect but it's the best solution I've come up with that doesn't require passphrases for every repository
        LAST_MTIME=$(find "$d" -type f -exec stat \{} --printf="%y\n" \; | sort -n -r | head -n 1)
        DAYS_SINCE=$(( ($(date +%s -d 'now') - $(date +%s -d "$LAST_MTIME")) / 86400))
        if (( DAYS_SINCE > 7 )); then
            message "$(basename $d) was not backed up in the last $DAYS_SINCE days!";
        fi
    done
}

function offsiteBackup {
    rclone sync -v --fast-list --transfers 16 --b2-hard-delete "$BACKUPS_DIR" "$DEST_DIR"
}

if [ "$1" = "setup" ]; then
    setUp
else
    checkLastBackups   || { message "Could not check last backups."; }
    offsiteBackup      || { message "Offsite backup was unsuccessful!";  exit 1; }
fi
