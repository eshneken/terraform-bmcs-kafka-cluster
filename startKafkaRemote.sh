#!/bin/bash

for a in ${BASH_ARGV[*]} ; do
    echo "starting Kafka/Zookeeper at node: $a"
    ssh -i userdata/private.key opc@$a -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "sh ~/startZookeeperKafka.sh" &
done
echo "start sequence complete"