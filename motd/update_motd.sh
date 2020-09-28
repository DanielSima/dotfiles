#!/bin/bash

#output file
motd="/home/daniel/dotfiles/laptop/motd/motd"
clear > $motd
# welcome
cat > $motd << 'EOL'

 __       __            __
|  \  _  |  \          |  \
| $$ / \ | $$  ______  | $$  _______   ______   ______ ____    ______
| $$/  $\| $$ /      \ | $$ /       \ /      \ |      \    \  /      \
| $$  $$$\ $$|  $$$$$$\| $$|  $$$$$$$|  $$$$$$\| $$$$$$\$$$$\|  $$$$$$\
| $$ $$\$$\$$| $$    $$| $$| $$      | $$  | $$| $$ | $$ | $$| $$    $$
| $$$$  \$$$$| $$$$$$$$| $$| $$_____ | $$__/ $$| $$ | $$ | $$| $$$$$$$$
| $$$    \$$$ \$$     \| $$ \$$     \ \$$    $$| $$ | $$ | $$ \$$     \
 \$$      \$$  \$$$$$$$ \$$  \$$$$$$$  \$$$$$$  \$$  \$$  \$$  \$$$$$$$


EOL

# date
printf "\n%s" "$(date)" >> $motd

# uptime
printf " | %s\n" "$(uptime -p)" >> $motd

# OS
if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    PRETTY_NAME="Linux"
fi
printf "%s | %s\n" "$PRETTY_NAME" "$(uname -r)" >> $motd

# System Params
priv_ip=`ip -o route get to 8.8.8.8         | sed -n 's/.*src \([0-9.]\+\).*/\1/p'`
pub_ip=`curl https://ipecho.net/plain -s`
load=`cat /proc/loadavg                     | awk '{print $2}'`
memory_usage=`free -m                       | awk '/Mem/ { printf("%3.1f%%", $3/($2+1)*100) }'`
memory_total=`free -g                       | awk '/Mem/ { printf("%3.0f", $2) }'`
swap_usage=`free -m                         | awk '/Swap/ { printf("%3.1f%%", $3/($2+1)*100) }'`
swap_total=`free -g                         | awk '/Swap/ { printf("%3.0f", $2) }'`
users=`users                                | wc -w`

#Color
Magenta="\u001b[35m"
Reset="\u001b[0m"

printf "\nPrivate IP:\t$Magenta%s$Reset\tPublic IP:\t$Magenta%s$Reset\n" $priv_ip $pub_ip >> $motd
printf "System load:\t$Magenta%s$Reset\t\tMemory usage:\t$Magenta%s$Reset of %sG\n" $load $memory_usage $memory_total >> $motd
printf "Local users:\t$Magenta%s$Reset\t\tSwap usage:\t$Magenta%s$Reset of %sG\n\n" $users $swap_usage $swap_total >> $motd

# Get disk usage (use 2s timeout for weak nfs mounts)
timeout --signal=kill 2s df -h | grep -E "^(/dev/|Filesystem)" >> $motd

# empty line
echo "" >> $motd
