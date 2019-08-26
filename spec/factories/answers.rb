FactoryBot.define do
  factory :answer do
    body { "MyText" }
    #question { :question }
    question

    trait :invalid do
      body { nil }
    end
  end
end
