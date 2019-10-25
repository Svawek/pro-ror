RSpec.shared_examples 'attached files' do |model|
  it 'have many attached files' do
    expect(model.new.files). to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
