#!/bin/bash -x

eval $(docker-machine env confluent)

export VERSION=4.1.2
export VERSION2=5.0.0

docker-compose down

