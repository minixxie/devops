#!/bin/bash

golangImage="minixxie/golang:1.7"

choice=$(dialog --menu "Choose Action" \
    28 100 40 \
    \
    "echo -n 'pkgUrl: ' && read pkgUrl && docker run --rm -w /go/src/app -v \"\$PWD\":/go/src/app $golangImage bash -c 'govendor add $pkgUrl'" \
        "govendor add <gopkg_uri>                                              " \
    "docker-compose -f ldev-docker-compose.yml rm -f" \
        "server: stop                                              " \
    "docker-compose -f ldev-docker-compose.yml build && docker-compose -f ldev-docker-compose.yml up -d && docker-compose -f ldev-docker-compose.yml logs -f" \
        "server: start                                              " \
3>&1 2>&3 > $(tty))

exec bash -c "$choice"
