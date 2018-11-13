require 'rubygems'
require 'roo'

if ARGV.empty?
  puts "You need to pass the filename when running the script - IE 'ruby report-generator.rb FILENAME.csv'"
  exit 1
end

#Edit these values depending on the report you want to run
filename = ARGV[0].to_s

# Required to prevent "Invalid date/time in zip entry" warning
Zip.warn_invalid_date = false

combined_config = Roo::Excelx.new('assets/mapping files/combined_dtt-fsat_human-readable-channel-map.xlsx')
report = Roo::CSV.new('assets/reports/'+filename)

report = report.to_a.drop(13)

report = report.to_h

#Create arrays for each column
combined_config_reference = combined_config.column(2).to_a.drop(1)
combined_config_dtt = combined_config.column(3).to_a.drop(1)
combined_config_fsat = combined_config.column(4).to_a.drop(1)

#Create hashmap for abstractor reference and dtt/fsat corresponding
combined_map = combined_config_reference.zip([combined_config_dtt.map(&:to_s), combined_config_fsat.map(&:to_s)].transpose).to_h

output = []
total_value = 0

#puts report
#puts " "
#puts " "
#puts combined_map

#Go over the hash map by each key - IE - each path within the report
report.each do |key, array|
	#Now we need to compare each path to a matching match found within the map
	combined_map.each do |k, a|
		#If a key matches 
		if key == a.at(0)
			#Add to total value (which will create a combined total)
			total_value = array.to_i
			#Once it has found one match, it should go over the same array again to see if the key can match a second value in the array - if it can - we care about the output
			report.each do |ke, ar|
				#This time we want to find the opposing value (likely freesat in the second array column) and compare to the rest of the report - if we get a match, we know its available of both platforms and thus we combine the total values
				if a.at(1) == ke
					total_value = total_value + ar.to_i
					#Push output to array
					output = output.push(k.to_s+","+total_value.to_s)
				end
			end
			#Push values for those without Freesat support (no match within secondary loop) - This is de-duplaicated later
			output = output.push(k.to_s+","+total_value.to_s)
			#Reset the value
			total_value = 0
		end
	end
end

#De-duplicate the output where we've added twice
output = output.uniq

#Load txt document to overwrite
File.open('assets/outputs/'+filename, "w+") do |f|
  f.puts(output)
end

puts 'Text file generated'