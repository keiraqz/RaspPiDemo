import time
from kafka import KafkaConsumer
import os
import redis


class Consumer(object):
	def __init__(self, group, topic):
		"""Initialize Consumer with kafka broker IP, and topic."""

		# for Kafka
		self.topic = topic
		self.group = group
		self.redisClient = redis.StrictRedis(host='localhost', port=6379, db=0)
		self.consumer = KafkaConsumer(self.topic,
                         bootstrap_servers=['localhost:9092'])

	def consume_topic(self):
		"""Consumes a stream of messages from the "twilio_trnx" topic.
		"""
		while True:
			try:
				for message in self.consumer:
					msg_info = message.value.decode()
					print msg_info
					self.redisClient.lpush("twilio_trnx", msg_info)
				self.consumer.commit()
			except:
				pass


if __name__ == '__main__':
	print "\nConsuming messages..."

	cons = Consumer(group="rasp_2", topic="twilio_trnx")
	cons.consume_topic()

