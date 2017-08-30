#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

cd "$scriptPath"
docker-compose up -d
