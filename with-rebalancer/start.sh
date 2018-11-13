#!/bin/bash -x

export VERSION=4.1.2
export VERSION2=5.0.0

eval $(docker-machine env confluent) || exit 1

docker-compose up
