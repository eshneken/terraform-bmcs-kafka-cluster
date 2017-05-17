#!/bin/sh

cd ~/kafka-install
bin/zookeeper-server-start.sh config/zookeeper.properties &
sleep 15
bin/kafka-server-start.sh config/server.properties &
