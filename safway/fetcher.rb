require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'


page = Nokogiri::HTML(open("http://safway.com/AboutUs/"))
page2 = "http://safway.com/AboutUs/getLocations.asp?"
page3 = "http://safway.com/AboutUs/getLocations2.asp?city="


root_url = "http://safway.com/"


menu_items = page.css("aside.aside-content-right form.branch-locator option").map{|i| i.text }


menu_items.each do |state|
p = {}
   search_state_url = Nokogiri::HTML(open(page2 + "state=" + state))
   grep = search_state_url.css("table.tableDefault tbody tr")
   grep.each do |grap|
   loc_name = grap.css("td")[0].css("b").text
  phone = grap.css("td")[0].text.split("Phone: ").last.split("\n").first.strip
  if grap.css('td')[1] != nil

address = grap.css('td')[1].text.chomp  
postal_code = address.split(//).last(5).join
address1 = address.split(",").first
address2 = address.split(",").last
map = grap.css('form#cities')
map.each do |di|
  ll = di.at('input')['value']
  
    search_city_url = Nokogiri::HTML(open(page3 + ll)) rescue nil
    next if search_city_url.nil?
    
     find_latlong = search_city_url.css("div#safway_main")
z = find_latlong.at("script").text
gg = z.split("var myLatLng = ").last
rps = gg.split("\t").first
lat = rps.split(",").first.tr("{lat: ","").chomp
longi = rps.split(",").last.tr("{long: ","").chomp
long = longi.chomp('};')

   p["loc_name"] = loc_name
   p["city"] = ll
   p["state"] = state
   p["postal_code"] = postal_code
   p["latitude"] = lat
   p["longitude"] = long
   p["phone"] = phone
   p["country"] = "USA"
   p["address1"] = address1
   p["address2"] = address2
   p["address3"] = loc_name + " " + state + " " + postal_code
   p["address_raw"] = address + " " + state + " USA"
   p["url"] = root_url + ll
 
  puts p.to_json

end
end
   end
   end
   
 
