User.destroy_all
Riddle.destroy_all
Riddlebook.destroy_all

5.times do
    User.create(name: Faker::Name.name)
end

Riddle.create(title: "Broken", context: "What has to be broken before you can use it?", answer: "An egg")
Riddle.create(title: "Tall, Young, Short", context: "I’m tall when I’m young, and I’m short when I’m old. What am I?", answer: "A candle")
Riddle.create(title: "28 Days", context: "What month of the year has 28 days?", answer: "All of them")
Riddle.create(title: "Full of Holes", context: "What is full of holes but still holds water?", answer: "A sponge")
Riddle.create(title: "Never Answer Yes", context: "What question can you never answer yes to?", answer: "Are you asleep yet?")

5.times do
    Riddlebook.create(user_id: User.all.sample.id, riddle_id: Riddle.all.sample.id)
end

