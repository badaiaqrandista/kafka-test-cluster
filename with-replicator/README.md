# Two clusters with replicator

This variant creates 2 clusters and 1 connect container. Their names are:

 * zookeeper1 + kafka1
 * zookeeper2 + kafka2
 * connect

Once all containers are up and running, you can run `./test-replicator.sh`, which will do these:

 * create the replicator connector, 
 * produce 10 records into `foo` topic
 * consume in the background with `foo_group` consumer group and timestamp interceptor
 * print all consumer group in cluster 1
 * print all consumer group in cluster 2
 * consume in cluster 2 with `foo_group` consumer group
