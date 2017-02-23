puts
puts "Adding labels"
["straightedge","drug-free","straightedge-curious","sober","drug-friendly"].each do |label|
  Label.create!(name: label)
  puts "label:  #{label}"
end

puts
puts "Adding diets"
%w(raw vegan vegetarian pescatarian kosher freegan omnivorous).each do |diet|
  Diet.create!(name: diet)
  puts "diet:  #{diet}"
end
