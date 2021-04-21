#!/bin/bash
# RCLONE UPLOAD CRON TAB SCRIPT
# chmod a+x /home/plex/scripts/rclone-upload.sh
# Type crontab -e and add line below (without #) and with correct path to the script
# * * * * * /home/plex/scripts/rclone-upload.sh >/dev/null 2>&1
# if you use custom config path add line bellow in line 20 after --log-file=$LOGFILE
# --config=/path/rclone.conf (config file location)

if pidof -o %PPID -x "$0"; then
   exit 1
fi

LOGFILE="/home/daniel/dotfiles/laptop/gdrive_backup.log"
FROM="/home/daniel/Documents/School/"
TO="gdrive_university:/"


# CHECK FOR FILES IN FROM FOLDER THAT ARE OLDER THAN 15 MINUTES
if find $FROM* -type f -mmin +15 | read
  then
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD STARTED" | tee -a $LOGFILE

  # MOVE FILES OLDER THAN 15 MINUTES
  rclone sync -v "$FROM" "$TO" --transfers=20 --checkers=20 --min-age 15m --error-on-no-transfer --log-file=$LOGFILE
  rcloneExitCode=$?

  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
  if [[ "$rcloneExitCode" != "0" && "$rcloneExitCode" != "9" ]]
    then
    sudo -u daniel DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send 'Error backing up!' --app-name='Google Drive Backup Script' --icon='folder-gdrive' --urgency="critical"
  elif [[ "$rcloneExitCode" != "9" ]] #9 - no files transfered
  then
    sudo -u daniel DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send 'Backup finished.' --app-name='Google Drive Backup Script' --icon='folder-gdrive' --urgency="low"
  fi
fi
exit
