FactoryBot.define do
  factory :video do
    user
    title { Faker::Lorem.word }
    url { 'https://youtu.be/uwU2YKYp1jg' }
  end
end
