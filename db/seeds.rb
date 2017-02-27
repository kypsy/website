puts
puts "Adding labels"
["straightedge","drug-free","straightedge-curious","sober"].each do |label|
  Label.create!(name: label)
  puts "label:  #{label}"
end

puts
puts "Adding diets"
%w(raw vegan vegetarian pescatarian kosher freegan omnivorous).each do |diet|
  Diet.create!(name: diet)
  puts "diet:  #{diet}"
end

puts
puts "Adding age ranges"
%w(18-29 30-39 40-49 50-59 60-69 70-79 80-89 90-99).each do |age_range|
  AgeRange.create!(name: age_range)
  puts "age range:  #{age_range}"
end
