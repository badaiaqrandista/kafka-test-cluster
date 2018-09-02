#!/bin/bash -x

export VERSION=5.0.0

eval $(docker-machine env confluent) || exit 1

docker-compose up
