include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'helper/rb') }
    end

    # after(:create) do
    #   award_attributes { "title"=>"1", "image"=> fixture_file_upload(Rails.root.join('app/view/awards', 'award.webp'), 'image/webp') }
    # end
  end
end
