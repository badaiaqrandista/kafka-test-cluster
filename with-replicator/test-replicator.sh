#!/bin/bash

[[ "TRACE" ]] && set -x

eval $(docker-machine env confluent)

# turn off committing internal consumer offsets to source
# "offset.topic.commit": false 
# turn off committing internal consumer offsets to dest
# "offset.timestamps.commit": false 
# turn off offset translation for consumer interceptors
# "offset.translator.tasks.max": 0
# run offset translator on separate task than the replicator (default is false)
# "offset.translator.tasks.separate": true
# number of offset translator tasks (some low # less than max tasks)
# "offset.translator.tasks.max": 1

create_replicator() {
  [ -f /tmp/replicator-created ] || return

  echo "Create Replicator"
  docker container exec connect \
     curl -X POST \
     -H "Content-Type: application/json" \
     --data '{
        "name": "replicator-from-1-to-2",
        "config": {
          "connector.class":"io.confluent.connect.replicator.ReplicatorSourceConnector",
          "key.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
          "value.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
          "src.zookeeper.connect": "quickstart.confluent.io:22181",
          "src.kafka.bootstrap.servers": "quickstart.confluent.io:19092,quickstart.confluent.io:19093,quickstart.confluent.io:19094",
          "dest.zookeeper.connect": "localhost:32181",
          "dest.kafka.bootstrap.servers": "quickstart.confluent.io:29092,quickstart.confluent.io:29093,quickstart.confluent.io:29094",
          "topic.whitelist": "foo"}}' \
     http://quickstart.confluent.io:28082/connectors

  touch /tmp/replicator-created
}

produce_into_foo_in_cluster_1() {
  [ -f /tmp/produced-into-foo ] || return

  echo "Console producer in Cluster 1"
  seq -f "a_%g" 10 | docker container exec --interactive connect kafka-console-producer --broker-list quickstart.confluent.io:19092 --topic foo

  touch /tmp/produced-into-foo
}

consume_from_foo_in_cluster_1() {
  echo "Console consumer in Cluster 1"
  docker container exec \
    --env CLASSPATH=/usr/share/java/kafka-connect-replicator/kafka-connect-replicator-5.0.0.jar \
    connect \
    kafka-console-consumer \
    --bootstrap-server quickstart.confluent.io:19092 \
    --topic foo \
    --from-beginning \
    --max-messages 10 \
    --timeout-ms 10000 \
    --consumer-property interceptor.classes=io.confluent.connect.replicator.offsets.ConsumerTimestampsInterceptor \
    --consumer-property group.id=foo_group \
    --consumer-property timestamps.topic.replication.factor=1
}

print_consumer_group_in_cluster_1() {
  echo "Consumer group in Cluster 1"
  docker container exec connect kafka-consumer-groups --bootstrap-server quickstart.confluent.io:19092 --describe --group foo_group
}

print_consumer_group_in_cluster_2() {
  echo "Consumer group in Cluster 2"
  docker container exec connect kafka-consumer-groups --bootstrap-server quickstart.confluent.io:29092 --describe --group foo_group
}

main() {
  create_replicator
  produce_into_foo_in_cluster_1
  consume_from_foo_in_cluster_1
  print_consumer_group_in_cluster_1
  echo "Wait 20 seconds before continuing"
  sleep 20
  print_consumer_group_in_cluster_2
  #consume_from_foo_in_cluster_2
  #print_consumer_group_in_cluster_2
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
