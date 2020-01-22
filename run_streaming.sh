#!/bin/bash

# python xxx.py {{ client_IP }} {{ partition_key}}
python auto_producer.py &
python twilio_producer.py &
python auto_consumer.py &
python twilio_consumer.py &