puts "Creating users..."
10.times do |i|
  User.create!(
    name: "User#{i + 1}"
  )
end

puts "Created #{User.count} users."