#!/bin/bash

[[ "TRACE" ]] && set -x

main() {

  if [ ! -f /acl_initialized ]; then
    SUCCESS=no
    while [ "no" == "$SUCCESS" ]; do
      kafka-acls --authorizer-properties zookeeper.connect=quickstart.confluent.io:22181 --add --allow-principal User:schemaregistry --operation All --topic '_schemas'
      if [ "$?" == "0" ]; then
        SUCCESS=yes
      fi
    done

    touch /acl_initialized
  fi

  while true; do sleep 60000; done
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
