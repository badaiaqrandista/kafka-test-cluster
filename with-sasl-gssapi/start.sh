#!/bin/bash -x

export VERSION=4.1.2

eval $(docker-machine env confluent) || exit 1

docker-compose up
