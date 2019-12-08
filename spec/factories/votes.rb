FactoryBot.define do
  factory :vote do
    votable { nil }
    choice { true }
  end
end
