FactoryBot.define do
  factory :url do
    url { "http://google.com" }
    association :urlable, factory: [:article]
  end
end
