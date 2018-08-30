#!/bin/bash -x

docker-machine ssh confluent 'ETH0_IP=$(ifconfig eth0 | grep "inet addr:" | cut -d: -f2 | awk "{ print $1 }"); echo ${ETH0_IP} quickstart.confluent.io confluent >> /etc/hosts'
