require 'sec_query'
require 'crack' # XML and JSON parsing require 'crack/json' # Only JSON parsing
require 'fileutils'

STOCK_SYMBOL = 'KEM'
company_name = SecQuery::Entity.find(STOCK_SYMBOL).name
puts company_name
share_counter = 0


# # Find all 13F-HR filings YESTERDAY
# open('original_data/form.20170210.idx', 'r') do |f|
#   open('parsed_data/20170210_13F_HR', 'w') do |f2|
#     f.each_line do |line|
#       f2.puts line.split.last if line.start_with? '13F-HR'
#     end
#   end
# end
#
# # Find all 13F-HR filings TODAY
# open('original_data/form.20170213.idx', 'r') do |f|
#   open('parsed_data/20170213_13F_HR', 'w') do |f2|
#     f.each_line do |line|
#       f2.puts line.split.last if line.start_with? '13F-HR'
#     end
#   end
# end

# TODO: Loop parsed 13F for each do the following code, replace the URI

example_xml = Net::HTTP.get_response(URI.parse('https://www.sec.gov/Archives/edgar/data/1120926/0001120926-17-000002.txt')).body

str1_markerstring = '<infoTable>'
str2_markerstring = '</infoTable>'
security_filing_table = example_xml.scan(/#{str1_markerstring}(.*?)#{str2_markerstring}/m)

security_filing_table.each do |company|
  amount_hash = Crack::XML.parse(company[0])
  # puts amount_hash['nameOfIssuer']

  str1_markerstring = '<sshPrnamt>'
  str2_markerstring = '</sshPrnamt>'
  str3_markerstring = '<titleOfClass>'

  company_name = amount_hash['nameOfIssuer'][/^(.+?)#{str3_markerstring}/m, 1]
  share_present_amount = amount_hash['nameOfIssuer'][/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]

  puts company_name
  puts share_present_amount

  puts '=========='
  puts "\n"
end

# TODO: Find the same institution's last 13F filing, then find the same stock again

# response = Crack::XML.parse(parsed_xml)
# puts response


# response = Crack::XML.parse(File.read('form.20170210.idx'))
# => {"menu"=>{"food"=>[{"name"=>"Waffles", "price"=>"5.95"}, {"name"=>"French Toast", "price"=>"4.50"}]}}

# puts response


# s = Net::HTTP.get_response(URI.parse('http://stackoverflow.com/feeds/tag/ruby/')).body
# Hash.from_xml(s).to_json


# company = SecQuery::Entity.find('aapl').name
#
# puts company
# puts company.filings.count
#
#
# puts company.filings.first.content


# a = SecQuery::Entity.find( "0001568839")
#
# puts a.name

# puts a.name

# filing = a.filings.first.content.file_id
# puts filing
#
# filehtml = File.new('test.html', 'w+')
# filehtml.puts filing
# filehtml.close

