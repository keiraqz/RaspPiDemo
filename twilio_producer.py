import random
import numpy
import sys
import six
import json
import os
import csv
import time
from datetime import datetime
from twilio.rest import TwilioRestClient
from kafka import KafkaProducer
import multiprocessing
from multiprocessing import Process

# twilio credential
with open('config', 'r') as f:
	TWILIO_CRED = json.load(f)

ACCOUNT_SID = str(TWILIO_CRED['ACCOUNT_SID'])
AUTH_TOKEN = str(TWILIO_CRED['AUTH_TOKEN'])


class Producer(object):
	def __init__(self):
		self.producer = KafkaProducer(bootstrap_servers=['localhost:9092'])
		self.zip_list = {}

	def load_zipcode(self):
		with open('data/zipcode_us.csv') as data_file:
			zipreader = csv.reader(data_file, delimiter=',')
			zipreader.next()
			for row in zipreader:
				zipcode = str(row[0])
				geocode = {
					"geocode" : {
						"lat": str(row[3]),
						"lng": str(row[4])
					}
				}
				self.zip_list[zipcode] = geocode

	def produce_twilio_msg(self):		
		while True:
			twilio_client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN)
			messages = twilio_client.messages.list(  
			) 

			for m in messages:
				# print m.sid
				if m.direction == "inbound":
					message_dict = {}
					message_dict["date"] = str(m.date_created)
					message_dict["from"] = m.from_
					message_dict["body"] = self.zip_list.get(m.body)
					if not message_dict["body"]:
						message_dict["body"] = self.zip_list.get("10001")
					message_info = json.dumps(message_dict)
					print message_info
					self.producer.send('twilio_trnx', str(message_info).encode('ascii'))
				twilio_client.messages.delete(m.sid)
			# time.sleep(5)
		
		
if __name__ == "__main__":
	prod = Producer()
	prod.load_zipcode()
	prod.produce_twilio_msg()
	
	# twilio stream
	# twilio_process = Process(target=prod.produce_twilio_msg)
	# auto stream
	# auto_process = Process(target=prod.produce_msgs)
	# twilio_process.start()
	# auto_process.start()
