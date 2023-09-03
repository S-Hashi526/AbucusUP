# coding: utf-8

User.create!(
  [
    {
      name: "管理者",
      email: "sample@email.com",
      employee_number: "0001",
      uid: "0001",
      password: "password",
      password_confirmation: "password",
      admin: true,
      superior: false
    },
    {
      name: "塾長",
      email: "superior-a@email.com",
      employee_number: "1001",
      uid: "1001",
      password: "password",
      password_confirmation: "password",
      admin: false,
      superior: true
    },
    {
      name: "上長B",
      email: "superior-b@email.com",
      employee_number: "1002",
      uid: "1002",
      password: "password",
      password_confirmation: "password",
      admin: false,
      superior: true
    },
    {
      name: "生徒A",
      email: "sample-1@email.com",
      employee_number: "1101",
      uid: "1101",
      password: "password",
      password_confirmation: "password",
      admin: false,
      superior: false
    }
  ]
)  

# 60.times do |n|
#   name = Faker::Name.name
#   email = "sample-#{n+1}@email.com"
#   password = "password"
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password)
# end