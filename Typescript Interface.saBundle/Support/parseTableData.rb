#!/usr/bin/env ruby
table_name = ARGV[0]

require 'csv'
puts "<pre><code>"
puts "interface #{table_name.split('_').collect(&:capitalize).join} {"
CSV.parse(STDIN.read, headers: true)  do |row|
  fieldType = "unknown"
  # Lots of if statements, couldn't get a shorthand OR to work
  fieldType = "string" if row['Type'].include? "text"
  fieldType = "string" if row['Type'].include? "char"
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
puts "</pre></code>"
