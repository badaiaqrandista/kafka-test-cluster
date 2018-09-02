#!/bin/bash

[[ "TRACE" ]] && set -x

main() {

  if [ ! -f /scram_initialized ]; then
    kafka-configs --zookeeper quickstart.confluent.io:22181 --alter --add-config 'SCRAM-SHA-256=[password=kafkabroker1-secret],SCRAM-SHA-512=[password=kafkabroker1-secret]' --entity-type users --entity-name kafkabroker1

    touch /scram_initialized
  fi

  while true; do sleep 60000; done
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
