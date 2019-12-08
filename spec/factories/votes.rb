FactoryBot.define do
  factory :vote do
    votable { nil }
    choice { true }
    user
  end
end
