FactoryBot.define do
  factory :profile do
    user
    about { "MyText" }
  end
end
