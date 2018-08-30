#!/bin/bash -x

export VERSION=3.3.0

eval $(docker-machine env confluent) || exit 1

docker-compose up
