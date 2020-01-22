from flask import jsonify

from app import app
from flask import render_template, request
import hashlib
from struct import *
import json
from time import gmtime, strftime
import redis


redisClient = redis.StrictRedis(host='localhost', port=6379, db=0)


# Front page
@app.route("/")
@app.route("/index")
def index():
	title = "Streaming Demo"
	return render_template("mapview.html")


# get event stream
@app.route('/auto_trnx', methods=['GET'])
def add_auto_trnx():
	jsonresponse = redisClient.lpop('auto_trnx')
	return jsonify(output=jsonresponse)


# get twilio msg
@app.route('/twilio_trnx', methods=['GET'])
def add_twilio_trnx():
	jsonresponse = redisClient.lpop('twilio_trnx')
	print jsonresponse
	return jsonify(output=jsonresponse)



if __name__ == '__main__':
	"Are we in the __main__ scope? Start test server."
	app.run(host='localhost',port=5000,debug=True)
