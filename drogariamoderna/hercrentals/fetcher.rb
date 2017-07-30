require 'nokogiri'
require 'open-uri'
require 'json'

page = Nokogiri::HTML(open("https://www.hercrentals.com/content/herc/en/locations/location_statewise_results.html"))
root_url = "https://www.hercrentals.com"

menu_items = page.css("ul.usaStates li.stateLink div.equpmnts a").map { |link| link['href'] }

menu_items.each do |cat|

  product = {}

  location_url = root_url + cat
  
  page1 = Nokogiri::HTML(open(location_url))
  product["loc_name"] = page1.css("div.store_location_details h1").text

  matchedString = product["loc_name"].scan(" Herc Rentals ProSolutions(")
  if matchedString.nil? || matchedString.empty?
    product["loc_number"] = product["loc_name"].split("Herc Rentals(").last.split(")").first 
  else 
     product["loc_number"] = product["loc_name"].split(" Herc Rentals ProSolutions(").last.split(")").first
  end
  product["address_1"] = page1.css("div.addSr p")[0].text
  product["address_2"] = page1.css("div.addSr p")[1].text
  product["postal_code"] = page1.css("div.location_add_box input#branchZipCode").map{ |invalue| invalue['value']}.first 
  product["city"] = page1.css("div.location_add_box input#city").map{ |invalue| invalue['value']}.first
  product["state"] = product["address_2"].split("#{product["city"]}, ").last.split(" #{product["postal_code"]}").first
  product["country"] = "USA"  
  product["longitude"] = page1.css("div.location_add_box input#longitude").map{ |invalue| invalue['value']}.first
  product["latitude"] = page1.css("div.location_add_box input#latitude").map{ |invalue| invalue['value']}.first
  product["phone"] = page1.css("div.location_add_box p")[3].text.split("Phone: ").last.split("\n").first
  product["hours_of_operation"] = page1.css("div.timetable table.table").to_html()
  
  puts product.to_json
 
end
