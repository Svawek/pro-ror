RSpec.shared_examples 'check links in model' do
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
end
