require 'mysql2'
require 'fileutils'

client = Mysql2::Client.new(
  :host => "localhost", 
  :username => "nate",
  :password => "DevPwd123*",
  :database => "sentry"
)

filetype_array = []
ext_array = []

res_file_sql = "SELECT Name, FileType_ID FROM res_file"
dict_filetypes_sql = "SELECT ID, Extension FROM dict_filetypes"

# create an array of hashes with Names and FileType_IDs from res_file
results = client.query(res_file_sql)
results.each do |row|
  filetype_array.push(row)
end

# create an array of hashes with IDs and Extensions from dict_filetypes
results = client.query(dict_filetypes_sql)
results.each do |row|
  ext_array.push(row)
end

# p filetype_array
# p ext_array
# p filetype_array.count

i = 0
while i < filetype_array.count

  file_temp = filetype_array[i]
  filename = file_temp["Name"]
  filetypeid = file_temp["FileType_ID"]
  ext_temp = ext_array[filetypeid-1]
  ext_id = ext_temp["ID"]
  extension = ext_temp["Extension"]

  if extension == ".jpeg .jpg"
    extension = ".jpg"
  elsif extension == ".htm .html"
    extension = ".html"
  elsif extension == ".tif .tiff"
    extension = ".tif"
  end
  
  puts "Filename: " + filename.to_s + "; File Type ID: " + filetypeid.to_s + "; Extension: " + extension
  puts "New file created: " + filename.to_s + extension
  puts ""

  File.rename("testimages/#{filename}", "testimages/#{filename}#{extension}")
 

  i += 1
end