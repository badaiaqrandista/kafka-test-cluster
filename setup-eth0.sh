#!/bin/bash -x

FILE=setup-eth0-remote.sh
echo 'ETH0_IP=$(ifconfig eth0 | grep "inet addr:" | cut -d: -f2 | cut -d" " -f1); echo ${ETH0_IP} quickstart.confluent.io confluent >> /etc/hosts' >$FILE
docker-machine scp $FILE confluent:
docker-machine ssh confluent "chmod +x $FILE; sudo ./$FILE; rm $FILE"
rm $FILE
