#!/bin/bash

################################################
#			Install & Config Zookeeper
################################################

wget http://www-eu.apache.org/dist/zookeeper/current/zookeeper-3.4.8.tar.gz -P ~/Downloads

sudo tar zxvf ~/Downloads/zookeeper-*.tar.gz -C /usr/local
sudo mv /usr/local/zookeeper-3.4.8/ /usr/local/zookeeper

sudo cp /usr/local/zookeeper/conf/zoo_sample.cfg /usr/local/zookeeper/conf/zoo.cfg

sudo nano /usr/local/zookeeper/conf/zoo.cfg 
######## Configure Zookeeper  ########
# # the directory where the snapshot is stored.
# # do not use /tmp for storage, /tmp here is just
# # example sakes.
# dataDir={{ zookeeper/data_dir }}
# ...
# # The number of snapshots to retain in dataDir
# autopurge.snapRetainCount=3
# # Purge task interval in hours
# # Set to "0" to disable auto purge feature
# autopurge.purgeInterval=1

sudo mkdir /var/lib/zookeeper
sudo touch /var/lib/zookeeper/myid
echo 'echo 1 >> /var/lib/zookeeper/myid' | sudo -s


sudo /usr/local/zookeeper/bin/zkServer.sh start
echo srvr | nc localhost 2181 | grep Mode
# Mode: standalone


################################################
#			Install & Config Kafka
################################################
# config file reference: https://github.com/jiaqi216/PiCluster/tree/master/kafka

wget http://www-us.apache.org/dist/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz -P ~/Downloads

sudo tar zxvf ~/Downloads/kafka_2.11-0.9.0.1.tgz -C /usr/local
sudo mv /usr/local/kafka_2.11-0.9.0.1 /usr/local/kafka

sudo nano /usr/local/kafka/config/server.properties
######## Configure Kafka  ########
# # The id of the broker. This must be set to a unique integer for each broker.
# broker.id=0
# ...
# # A comma seperated list of directories under which to store log files
# log.dirs={{ kafka/log_dir }}
# ...
# # The minimum age of a log file to be eligible for deletion
# log.retention.hours=2  
# ...
# # Zookeeper connection string (see zookeeper docs for details).
# # This is a comma separated host:port pairs, each corresponding to a zk
# # server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# # You can also append an optional chroot string to the urls to specify the
# # root directory for all kafka znodes.
# zookeeper.connect=localhost:2181 


######## kafka-server-start.sh  ########
sudo nano /usr/local/kafka/bin/kafka-server-start.sh
######## Setup JMX port  ########
# Add the following on the top of the file after all the comments
# # …
# # …
# export JMX_PORT=${JMX_PORT:-9999}
# export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M" # for Raspberry Pi: the runtime JVM memory is small


######## kafka-run-class.sh  ########
# for Raspberry Pi: JAVA is running as -client instead of -server
sudo nano /usr/local/kafka/bin/kafka-run-class.sh 
# KAFKA_JVM_PERFORMANCE_OPTS="-client ....."
### if 2.8 kafka:
# KAFKA_JVM_PERFORMANCE_OPTS="-client -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true"

######## Start Kafka Server  ########
sudo /usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties &


######## Create Topics  ########
/usr/local/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic twilio_trnx
/usr/local/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic auto_trnx

# check topics
/usr/local/kafka/bin/kafka-topics.sh --describe --zookeeper localhost:2181

# delete topics
/usr/local/kafka/bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic twilio_trnx
/usr/local/kafka/bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic auto_trnx

# check from terminal
/usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic auto_trnx
/usr/local/kafka/bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic auto_trnx --from-beginning


################################################
#			Install Redis
################################################
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make

# Start Redis Server
nohup redis-server &

# Test Redis
redis-cli ping
