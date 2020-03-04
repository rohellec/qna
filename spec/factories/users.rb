FactoryBot.define do
  sequence(:email) { |n| "address#{n}@example.com" }

  factory :user, aliases: [:author] do
    email
    password { "qwerty" }
    password_confirmation { "qwerty" }
  end

  trait :invalid do
    email { "" }
    password { "" }
    password_confirmation { "" }
  end
end
