#!/bin/bash

scriptPath=$(cd $(dirname $0); pwd)

GOLANG=1 #default

ls "$scriptPath"/*.go > /dev/null 2>&1
if [ $? -eq 0 ]
then
	GOLANG=1
fi
ls "$scriptPath"/*.js > /dev/null 2>&1
if [ $? -eq 0 ]
then
	JS=1
fi

if [ "$GOLANG" == 1 ]
then

golangImage="minixxie/golang:1.8"
dockerRunGolang="docker run -it --rm --net ldev-backend -w /go/src/app -v \"\$PWD\":/go/src/app $golangImage "
choice=$(dialog --menu "Choose Action" \
    28 100 40 \
    \
    "docker ps -a" \
        "docker process list                                                                                         " \
    "docker stats \$(docker-compose -f ldev-docker-compose.yml config --services)" \
        "docker stats" \
    "docker ps -a | grep Exited | grep -v 'Exited (0)' | awk '{print \$1}' | xargs docker rm -f" \
        "rm failed containers" \
    "docker rmi \$(docker images | grep '<none>' | awk \"{print \$3}\")" \
        "rm unused images" \
    "#=== server ===#"          "#=== server ===" \
    "docker-compose -f ldev-docker-compose.yml stop && docker-compose -f ldev-docker-compose.yml rm -f" \
        "server: stop                                              " \
    "docker-compose -f ldev-docker-compose.yml build && docker-compose -f ldev-docker-compose.yml up -d && docker-compose -f ldev-docker-compose.yml logs -f" \
        "server: start                                              " \
    "docker-compose -f ldev-docker-compose.yml stop && docker-compose -f ldev-docker-compose.yml rm -f  &&  docker-compose -f ldev-docker-compose.yml build && docker-compose -f ldev-docker-compose.yml up -d && docker-compose -f ldev-docker-compose.yml logs -f" \
        "server: stop & start                                              " \
    "docker-compose -f ldev-docker-compose.yml logs -f" \
        "server: logs                                              " \
    "#=== GOLANG ===#"          "#=== GOLANG ===" \
    "$dockerRunGolang bash -c \"govendor init\"" \
        "govendor init" \
    "echo -n 'pkgUrl: ';read pkgUrl;$dockerRunGolang bash -c \"govendor fetch \$pkgUrl\"" \
        "govendor fetch <gopkg_uri>                                              " \
    "docker run --rm --net ldev-backend -w /go/src/app -v \"\$PWD\":/go/src/app $golangImage bash -c \"cd test && go test\"" \
        "go test" \
    "docker run -it --rm --net ldev-backend -w /go/src/app -v \"\$PWD\":/go/src/app $golangImage bash" \
        "go container" \
3>&1 2>&3 > $(tty))

elif [ "$JS" == 1 ]
then

nodejsImage="node:7.8.0-alpine"
choice=$(dialog --menu "Choose Action" \
    28 100 40 \
    \
    "docker ps -a" \
        "docker process list                                                                                         " \
    "docker stats \$(docker-compose -f ldev-docker-compose.yml config --services)" \
        "docker stats" \
    "docker ps -a | grep Exited | grep -v 'Exited (0)' | awk '{print \$1}' | xargs docker rm -f" \
        "rm failed containers" \
    "docker rmi \$(docker images | grep '<none>' | awk \"{print \$3}\")" \
        "rm unused images" \
    "#=== server ===#"          "#=== server ===" \
    "docker-compose -f ldev-docker-compose.yml stop && docker-compose -f ldev-docker-compose.yml rm -f" \
        "server: stop                                              " \
    "docker-compose -f ldev-docker-compose.yml build && docker-compose -f ldev-docker-compose.yml up -d && docker-compose -f ldev-docker-compose.yml logs -f" \
        "server: start                                              " \
    "docker-compose -f ldev-docker-compose.yml stop && docker-compose -f ldev-docker-compose.yml rm -f  &&  docker-compose -f ldev-docker-compose.yml build && docker-compose -f ldev-docker-compose.yml up -d && docker-compose -f ldev-docker-compose.yml logs -f" \
        "server: stop & start                                              " \
    "#=== JS ===#"          "#=== JS ===" \
    "docker run --rm --net ldev-backend -w /usr/src/app -v \"\$PWD\":/usr/src/app $nodejsImage bash -c \"npm test\"" \
        "nodejs test" \
    "docker run -it --rm --net ldev-backend -w /usr/src/app -v \"\$PWD\":/usr/src/app $nodejsImage bash" \
        "nodejs container" \
3>&1 2>&3 > $(tty))

fi

dockerMachine=$(which docker-machine)
if [ "$dockerMachine" != "" ]
then
    eval $(docker-machine env)
fi
exec bash -c "$choice"
