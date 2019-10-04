FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec/support', 'controller_helpers.rb'), 'helper/rb') }
    end
  end
end
