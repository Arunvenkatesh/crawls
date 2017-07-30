require 'nokogiri'
require 'open-uri'
require 'json'

docs1 = JSON.parse(open("https://api.bluelinerental.io/branches/?rentalCompany=37667").read)
docs2 = JSON.parse(open("https://api.bluelinerental.io/branches/?rentalCompany=37666").read)

docs = docs1['data'].values + docs2['data'].values

docs.flatten.each do |doc|
  p = {}
  loc_name = doc["name"].split("- ")[1];
  p["loc_name"] = loc_name
  p["loc_number"] = doc["storeNumber"];
  p["city"] = doc["city"];
  p["state"] = doc["state"];
  p["postal_code"] = doc["postalCode"];
  p["latitude"] = doc["latitude"];
  p["longitude"] = doc["longitude"];
  p["phone"] = doc["phone"];
  p["email"] = doc["email"];
  p["country"] = doc["country"];
  p["address1"] = doc["addressLine1"];
  p["address2"] = doc["addressLine2"];
  p["address3"] = doc["city"] + doc["state"] + doc["postalCode"];
  p["address_raw"] =  doc["storeNumber"] + " " + loc_name + doc["city"] + doc["state"] + doc["postalCode"]
  p["url"] = "https://www.bluelinerental.com/branches-map/~/branch/" + doc["id"].to_s
  puts p.to_json
end
