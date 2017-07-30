require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'


page = Nokogiri::XML(open("http://drogariamoderna.com.br/lojas?ajax=1&all=1"))
docs = page.css("marker")

docs.each do |doc| 
	p = {}
p["loc_name"] = doc["name"]
p["loc_number"] = doc["id_store"]
p["address_1"] = doc["addressNoHtml"].split(",")[0]
p["address_2"] = doc["addressNoHtml"].split(",")[1]
p["city"] = doc["addressNoHtml"].split(",")[1].split(" ").last
p["postal_code"] = doc["addressNoHtml"].split(",")[1].scan(/\d*\-\d+/).first
p["phone"] = doc["phone"]
p["latitude"] = doc["lat"]
p["longitude"] = doc["lng"]
p["country"] = "Brazil"
p["address_raw"] = doc["addressNoHtml"]
puts p.to_json
end
