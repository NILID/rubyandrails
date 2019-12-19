FactoryBot.define do
  factory :article do
    title { "Title" }
    content { "MyText" }
    user

    trait :published do
      after(:create) { |u| u.update_attribute(:statuses_mask, 2) }
    end

    trait :deleted do
      after(:create) { |u| u.update_attribute(:statuses_mask, 4) }
    end
  end
end
