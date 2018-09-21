#!/bin/bash -x

eval $(docker-machine env confluent)

export VERSION=5.0.0

docker-compose down

