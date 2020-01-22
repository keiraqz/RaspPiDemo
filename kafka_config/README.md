# Running Kafka on Raspberry Pi Cluster

This simple README covers how to change some config for Kafka so that it can run on a Raspberry Pi cluster.

<img src="https://github.com/keiraqz/RaspPiDemo/blob/master/flask/app/static/img/thePi.jpg" width="300" /> 

## Install Zookeeper on the cluster

- Download & Config Zookeeper
	
	Some blog posts have covered this topic. 
	
	For example: [Installing Zookeeper on RaspberryPi](https://gist.github.com/acsheller/6653072)

- Start Zookeeper on All nodes

	```
	sudo /usr/local/zookeeper/bin/zkServer.sh start
	```

- Check whether the node is leader or follower

	```
	echo srvr | nc localhost 2181 | grep Mode
	```
	
## Install Kafka on the cluster

- Download Kafka on all nodes

	```
	wget http://www-us.apache.org/dist/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz -P ~/Downloads
	sudo tar zxvf ~/Downloads/kafka_2.11-0.9.0.1.tgz -C /usr/local
	sudo mv /usr/local/kafka_2.11-0.9.0.1 /usr/local/kafka
	
	```

- Config **```config/server.properties```**

	```
	sudo nano /usr/local/kafka/config/server.properties
	```
	
	* Sample file
	
	```
	# The id of the broker. This must be set to a unique integer for each broker.
	broker.id=0 # increment this for each node (broker.id=1 on 2nd node etc.)
	#...
	# A comma seperated list of directories under which to store log files
	log.dirs=your/kafka/log/dir # change to wherever you want the log to be
	#...
	# The minimum age of a log file to be eligible for deletion
	log.retention.hours=2 # change this based on your need
	#...
	# Zookeeper connection string (see zookeeper docs for details).
	# This is a comma separated host:port pairs, each corresponding to a zk
	# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
	# You can also append an optional chroot string to the urls to specify the
	# root directory for all kafka znodes.
	zookeeper.connect= <public_dns_1>:2181,<public_dns_2>:2181,<public_dns_3>:2181
	```
	
- Config **```bin/kafka-server-start.sh```**

	```
	sudo nano /usr/local/kafka/bin/kafka-server-start.sh
	```
	
	* Add the following after all comments:

	```
	export JMX_PORT=${JMX_PORT:-9999}
	``` 
	
	* For Raspberry Pi, if the memory on the Pi is small, the default settings (usually 1G) will have trouble starting JVM. Add the following:
	
	```
	export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M" 
	```
	
- Config **```bin/kafka-run-class.sh```**
	
	For Raspberry Pi OS: Java is running as ```-client``` instead of ```-server```. However, default Kafka setting runs Java as ```-server```. To change that:

	```
	sudo nano /usr/local/kafka/bin/kafka-run-class.sh
	```
	
	* Find ```KAFKA_JVM_PERFORMANCE_OPTS``` and change to:
	
	```
	KAFKA_JVM_PERFORMANCE_OPTS="-client ....."
	
	### if 2.8 kafka:
	# KAFKA_JVM_PERFORMANCE_OPTS="-client -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true"
	```
	
- Start Kafka on all nodes

	```
	sudo /usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties &
	```
	
## Other References

- [Unrecognized VM option '+UseCompressedOops'](http://stackoverflow.com/questions/22325364/unrecognized-vm-option-usecompressedoops-when-running-kafka-from-my-ubuntu-in)
- [Kafka Jave Memory Setting](http://stackoverflow.com/questions/21448907/kafka-8-and-memory-there-is-insufficient-memory-for-the-java-runtime-environme)
- [Run Java with "-client" instead of "-server"](http://blog.arungupta.me/wildfly-on-raspberry-pi-techtip-24/)
