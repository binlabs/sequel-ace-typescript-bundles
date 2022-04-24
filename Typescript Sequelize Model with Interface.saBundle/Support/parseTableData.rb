#!/usr/bin/env ruby
require 'csv'

# General Variables
table_name = ARGV[0]
csv_data = STDIN.read
class_name = table_name.split('_').collect(&:capitalize).join
interface_name = table_name.split('_').collect(&:capitalize).join + 'Iface'
single_return = "\n"
# Model Variables
allow_null_false = "allowNull: false"
allow_null_true = "allowNull: true"
data_type_boolean = "type: DataTypes.BOOLEAN"
data_type_date = "type: DataTypes.DATE"
data_type_decimal = "type: DataTypes.DECIMAL"
data_type_double = "type: DataTypes.DOUBLE"
data_type_fixed = "type: DataTypes.FIXED"
data_type_float = "type: DataTypes.FLOAT"
data_type_integer = "type: DataTypes.INTEGER"
data_type_interger_unsigned = "type: DataTypes.INTEGER.UNSIGNED"
data_type_json = "type: DataTypes.JSON"
data_type_numeric = "type: DataTypes.NUMBER"
data_type_string = "type: DataTypes.STRING"
default_value_date_now = "defaultValue: literal('NOW()')"
default_value_empty_string = "defaultValue: ''"
default_value_false = "defaultValue: false"
default_value_null = "defaultValue: null"
default_value_true = "defaultValue: true"
default_value_zero = "defaultValue: 0"

# Print the heading and opening of the HTML code wrapper
puts "<h3>Sequelize Model and Interface for #{class_name}</h3>"
puts "<div class='clipboard'><button type='button' class='btn-clipboard' title='Copy to clipboard' data-target-id='#{class_name}'>Copy</button></div>"
puts "<div class='highlight'><pre><code id='#{class_name}'>"

# Print the imports
puts "import { DataTypes, Model, InitOptions, ModelAttributes, literal } from 'sequelize'"
puts "// Uncomment the following line and update the import location"
puts "// import sequelize from 'location_of_your_sequelize_database_instance'"
puts single_return

# Print the interface
puts "interface #{interface_name} {"
CSV.parse(csv_data, headers: true)  do |row|
  # TODO: Lots of if statements, try to find a better way to do this
  # Field Types
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
puts single_return

# Print the model
puts "const tableName = '#{table_name}'"
puts single_return
puts "const columns: ModelAttributes = {"
CSV.parse(csv_data, headers: true)  do |row|
  dataType = "unknown"
  # Lots of if statements, couldn't get a shorthand OR to work
  dataType = data_type_string if row['Type'].include? "text"
  dataType = data_type_string if row['Type'].include? "char"
  dataType = data_type_json if row['Type'].include? "json"
  dataType = data_type_date if row['Type'].include? "date"
  dataType = data_type_date if row['Type'].include? "datetime"
  dataType = data_type_fixed if row['Type'].include? "fixed"
  dataType = data_type_float if row['Type'].include? "float"
  dataType = data_type_integer if row['Type'].include? "int"
  dataType = data_type_interger_unsigned if row['Type'] =~ /int.*unsigned/
  dataType = data_type_interger_unsigned if row['Type'].include? "dec"
  dataType = data_type_double if row['Type'].include? "doub"
  dataType = data_type_numeric if row['Type'].include? "numeric"
  dataType = data_type_date if row['Type'].include? "year"
  dataType = data_type_boolean if row['Type'].include? "tinyint"
  dataType = data_type_boolean if row['Type'].include? "bool"
  # Allow Null
  allowNull = allow_null_true
  allowNull = allow_null_true if row['Null'] == "NO"
  # Default Value
  defaultValue = default_value_empty_string
  defaultValue = default_value_date_now if row['Type'] == "CURRENT_TIMESTAMP"
  defaultValue = default_value_null if row['Default'] == "NULL"
  defaultValue = default_value_true if row['Default'] == "true"
  defaultValue = default_value_false if row['Default'] == "false"
  defaultValue = default_value_zero if row['Default'] == "0"
  puts "  #{row['Field']}: { #{allowNull}, #{defaultValue}, #{dataType} },"
  
end
puts "}"
puts single_return

# Print the model options
puts "const options: Omit&lt;InitOptions&lt;Model&gt;, 'sequelize'&gt; = {"
puts "  modelName: tableName,"
puts "}"
puts single_return
puts "class #{class_name} extends Model\<#{interface_name}\> {}"
puts single_return
puts "#{class_name}.init(columns, { ...options, sequelize })"
puts single_return
puts "export default #{class_name}"
puts single_return
# Print the closing of the HTML code wrapper
puts "</code></pre></div>"
