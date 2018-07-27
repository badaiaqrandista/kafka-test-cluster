# Kafka test cluster

Each directory in this repository is a self-contained Kafka clusters made of Docker containers. All you have to do is execute `docker-compose up` and it should start. 

It is based on the excellent Confluent's docker images: https://github.com/confluentinc/cp-docker-images

It is written to be executed in Linux docker-machine, as explained in: https://docs.confluent.io/current/installation/docker/docs/tutorials/clustered-deployment.html#docker-client-setting-up-a-three-node-kafka-cluster

```
docker-machine create --driver virtualbox --virtualbox-memory 6000 confluent
```

And you have to execute this in every shell you want to run `docker` command in:

```
eval $(docker-machine env confluent)
```

The docker machine must have the following line in `/etc/hosts` to ensure it can resolve its FQDN:

```
X.X.X.X quickstart.confluent.io confluent
```

Which can be done by executing this inside the docker machine once:

```
export ETH0_IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo ${ETH0_IP} quickstart.confluent.io confluent >> /etc/hosts
```

Its directory is named based on its specific setup. When I need a new variant, I will create a new directory and copy everything.

 * with-sasl_ssl-and-schema-registry

