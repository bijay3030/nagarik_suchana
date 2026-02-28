FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { "Password1!" }
    password_confirmation { "Password1!" }
    role { :user }

    trait :admin do
      role { :admin }
      email { "admin@example.com" }
    end

    trait :business do
      role { :business }
      email { "business@example.com" }
    end

    trait :with_invalid_email do
      email { "not-an-email" }
    end
  end
end
