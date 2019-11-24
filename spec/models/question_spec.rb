require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one(:award).dependent(:destroy) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_behaves_like 'attached files', Question
  it_behaves_like 'check links in model'
end
