#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

httpsCertsPath=$(dialog --inputbox "nginx-proxy: HTTPS Certs Path" 0 0 ~/https-certs 3>&1 2>&3 >$(tty))

cd "$scriptPath"
HTTPS_CERTS_PATH=$httpsCertsPath docker-compose up -d
