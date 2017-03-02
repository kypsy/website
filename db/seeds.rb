# TODO delete from app, then in here
puts
puts "Adding labels"
["straightedge","drug-free","straightedge-curious","sober"].each do |label|
  Label.create!(name: label)
  puts "label:  #{label}"
end



puts
puts "Adding interests"
["Art Museums","Baseball Games","Space Exploration","Science","Computers"].each do |interest|
  Interest.create!(name: interest)
  puts "interest:  #{interest}"
end

puts
puts "Adding activities"
["Swimming","Clubbing","Hiking","Reading","Dancing"].each do |activity|
  Activity.create!(name: activity)
  puts "activity:  #{activity}"
end

puts
puts "Adding age ranges"
["rather not say", "18-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80-89", "90-99"].each do |age_range|
  AgeRange.create!(name: age_range)
  puts "age range:  #{age_range}"
end
