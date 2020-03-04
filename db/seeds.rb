User.destroy_all
Riddle.destroy_all
Riddlebook.destroy_all

5.times do
    User.create(name: Faker::Name.name)
end

5.times do
    Riddle.create(title: Faker::Book.title, context: Faker::Quotes::Shakespeare.hamlet_quote, answer: Faker::Kpop.iii_groups)
end

5.times do
    Riddlebook.create(user_id: User.all.sample.id, riddle_id: Riddle.all.sample.id)
end

