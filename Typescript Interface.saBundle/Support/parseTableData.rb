#!/usr/bin/env ruby
table_name = ARGV[0]

require 'csv'

interface_name = table_name.split('_').collect(&:capitalize).join
puts "<h3>Typescript Interface for #{table_name}</h3>"
puts "<div class='clipboard'><button type='button' class='btn-clipboard' title='Copy to clipboard' data-target-id='#{interface_name}'>Copy</button></div>"
puts "<div class='highlight'><pre><code id='#{interface_name}'>"
puts "interface #{interface_name}Iface {"
CSV.parse(STDIN.read, headers: true)  do |row|
  # TODO: Lots of if statements, try to find a better way to do this
  fieldType = "unknown"
  fieldType = "string" if row['Type'].include? "text"
  fieldType = "string" if row['Type'].include? "char"
  fieldType = "string" if row['Type'].include? "json"
  fieldType = "Date" if row['Type'].include? "date"
  fieldType = "DateTime" if row['Type'].include? "datetime"
  fieldType = "number" if row['Type'].include? "fixed"
  fieldType = "number" if row['Type'].include? "float"
  fieldType = "number" if row['Type'].include? "int"
  fieldType = "number" if row['Type'].include? "dec"
  fieldType = "number" if row['Type'].include? "doub"
  fieldType = "number" if row['Type'].include? "numeric"
  fieldType = "number" if row['Type'].include? "year"
  fieldType = "boolean" if row['Type'].include? "tinyint"
  fieldType = "boolean" if row['Type'].include? "bool"
  puts "  #{row['Field']}: #{fieldType}"
end
puts "}"
puts "</code></pre></div>"
