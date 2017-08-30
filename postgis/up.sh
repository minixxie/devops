#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

pass=$(dialog --inputbox "Postgres Root password" 0 0 hello123 3>&1 2>&3 >$(tty))

cd "$scriptPath"
POSTGRES_PASSWORD=$pass docker-compose up -d
