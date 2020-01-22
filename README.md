# RaspPiDemo
![Image of Demo](/flask/app/static/img/auto.jpg)
![Image of Text](/flask/app/static/img/text.jpg)

## Install Zookeeper | Kafka | Redis

[NOTE] don't run the script.. it's a reference..

- refer to [install_tools.sh](https://github.com/keiraqz/RaspPiDemo/blob/master/install_tools.sh)

- other reference
	- [Unrecognized VM option '+UseCompressedOops'](http://stackoverflow.com/questions/22325364/unrecognized-vm-option-usecompressedoops-when-running-kafka-from-my-ubuntu-in)
	- [Kafka Jave Memory Setting](http://stackoverflow.com/questions/21448907/kafka-8-and-memory-there-is-insufficient-memory-for-the-java-runtime-environme)
	- [Run Java with "-client" instead of "-server"](http://blog.arungupta.me/wildfly-on-raspberry-pi-techtip-24/)

## Kafka Config


####2 topics

- auto_trnx: for auto streaming
- twilio_trnx: for Twilio


## Install on the Pi

```
#setup
conda create --name rasp_pi python=2
source activate rasp_pi

pip install kafka-python
pip install twilio
pip install flask
pip install numpy
pip install redis
```

## To start the demo

- run both consumer & producer

	```
	bash run_streaming.sh
	```

- start flask app

	```
	cd flask
	python run.py
	```
