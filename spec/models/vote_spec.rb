require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should allow_value(%w(true false)).for(:choice) }
  
  it { should belong_to :votable }
  it { should belong_to :user }
end
