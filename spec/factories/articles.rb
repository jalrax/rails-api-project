FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "sample-title#{n}" }
    content { "Sample content" }
    sequence(:slug) { |n| "sample-article#{n}" }
  end
end
