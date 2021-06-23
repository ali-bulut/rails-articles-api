FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "alibulut #{n}" }
    name { "Ali Bulut" }
    url { "http://alibulut.net" }
    avatar_url { "http://alibulut.net/images/avatar" }
    provider { "github" }
  end
end
