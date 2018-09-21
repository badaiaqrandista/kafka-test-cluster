# Kafka test cluster

Each directory in this repository is a self-contained Kafka clusters made of Docker containers. All you have to do is execute `docker-compose up` and it should start. 

It is based on the excellent Confluent's docker images: https://github.com/confluentinc/cp-docker-images

It is written to be executed in Linux docker-machine, as explained in: https://docs.confluent.io/current/installation/docker/docs/tutorials/clustered-deployment.html#docker-client-setting-up-a-three-node-kafka-cluster

# Quickstart

To start docker compose with-ssl:

```
cd kafka-test-cluster
docker-machine create --driver virtualbox --virtualbox-memory 6000 confluent
./setup-eth0.sh

cd with-ssl
./start.sh
```

And you have to execute this in every shell you want to run `docker` command in:

```
eval $(docker-machine env confluent)
docker container logs -f kafka1
```

