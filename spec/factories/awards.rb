FactoryBot.define do
  factory :award do
    title { "MyString" }
    image { fixture_file_upload(Rails.root.join('app/views/awards', 'award.webp'), 'image/webp') }
    question { nil }
    user { nil }
  end
end
