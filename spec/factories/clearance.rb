FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { "password" }
  end

  trait :with_providers do
    after :build do |user|
      2.times { create(:provider, user: user) }
    end
  end
end
