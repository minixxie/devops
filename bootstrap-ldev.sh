#!/bin/bash

scriptPath=$(cd `dirname $0`; pwd)

choices=$(dialog --checklist "Choose Components to setup:" 21 60 14 \
1 nginx-proxy on \
2 mariadb on \
3 postgres on \
4 redis off \
5 mongo off \
6 tidb off \
7 postgis off \
8 cockroachdb off \
3>&1 2>&3 >$(tty))

dockerMachine=$(which docker-machine)
if [ x"$dockerMachine" != x"" ]
then
	eval $(docker-machine env)
fi

for choice in $choices
do
	choice=$(echo -n "$choice" | sed 's/"//g')
	echo "choice: $choice"
	if [ "$choice" == 1 ]; then "$scriptPath"/nginx-proxy/up.sh ; fi
	if [ "$choice" == 2 ]; then "$scriptPath"/mariadb/up.sh ; fi
	if [ "$choice" == 3 ]; then "$scriptPath"/postgres/up.sh ; fi
	if [ "$choice" == 4 ]; then "$scriptPath"/redis/up.sh ; fi
	if [ "$choice" == 5 ]; then "$scriptPath"/mongo/up.sh ; fi
	if [ "$choice" == 6 ]; then "$scriptPath"/tidb/up.sh ; fi
	if [ "$choice" == 7 ]; then "$scriptPath"/postgis/up.sh ; fi
	if [ "$choice" == 8 ]; then "$scriptPath"/cockroachdb/up.sh ; fi
done
