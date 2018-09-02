FROM confluentinc/cp-zookeeper:5.0.0

ARG COMMIT_ID=unknown
LABEL io.confluent.docker.git.id=$COMMIT_ID
ARG BUILD_NUMBER=-1
LABEL io.confluent.docker.build.number=$BUILD_NUMBER
LABEL io.confluent.docker=true

ADD ./config.sh /config.sh

ENTRYPOINT ["/config.sh"]
