#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

echo 'Downloading:'
curl -L https://bit.ly/glances | /bin/bash

echo 'Starting service:'
sudo mkdir -p /etc/glances
sudo ln -sf $(DIR)/glances.conf /etc/glances/glances.conf
sudo ln -sf $(DIR)/glances.service /etc/systemd/system/glances.service
sudo systemctl enable glances
sudo systemctl start glances

echo 'Done.'
