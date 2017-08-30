#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

pass=$(dialog --inputbox "MariaDB Root password" 0 0 hello123 3>&1 2>&3 >$(tty))

cd "$scriptPath"
MYSQL_ROOT_PASSWORD=$pass docker-compose up -d
