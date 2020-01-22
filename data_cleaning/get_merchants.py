import json
from pprint import pprint

with open('merchants.json') as data_file:
	data = json.load(data_file)

merchants_geo = []

for i in range(len(data)):
	try:
		if not (data[i]['geocode']['lat'] == 0 and data[i]['geocode']['lng'] == 0):
			print data[i]
			merchants_geo.append(data[i])
	except:
		pass


with open('merchants_geo.json', 'w') as output_file:
	json.dump(merchants_geo, output_file)
