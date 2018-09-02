#!/bin/bash -x

eval $(docker-machine env confluent)

export VERSION=4.1.2

docker-compose down

