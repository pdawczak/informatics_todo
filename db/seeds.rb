# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['Andrew', 'Michael', 'Laura', 'Harry'].each do |name|
  User.create(
    email: "#{name}@example.com",
    password: 'example123',
    password_confirmation: 'example123'
  )
end

user_ids = User.pluck(:id)

[
  'Clean up desk', 'Water the plants', 'Have coffee', 'Go to a meeting',
  'Answer email', 'Order pizza', 'Go to stand-up', 'Fix that bug',
  'Go to lunch', 'Do great stuff'
].each do |desc|
  status = Todo.status.values.sample
  Todo.create(
    description: desc,
    status: status,
    requester_id: user_ids.sample,
    assignee_id: status == 'new' ? nil : user_ids.sample
  )
end
