require 'faker'

Wikipage.destroy_all
User.destroy_all


10.times do
    User.create!(
      username: Faker::Internet.user_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password(6)
  )
end
users = User.all


50.times do
  Wikipage.create!(
    title:  Faker::Lorem.words(3).join(" "),
    body:   Faker::Lorem.paragraph(3),
    user:   users.sample
  )
end
wikipages = Wikipage.all



User.create!(
  username: "admin",
  email: "admin@admin.com",
  password: "123456",
  role: "admin"
)


User.create!(
    username:   "standard",
    email:      "standard@standard.com",
    password:   "helloworld",
    role:       "standard"
)

User.create!(
    username:   "premium",
    email:      "premium@premium.com",
    password:   'helloworld',
    role:       'premium'
)



puts "Seed finished"
puts "#{Wikipage.count} wikis created"
puts "#{User.count} users created"
