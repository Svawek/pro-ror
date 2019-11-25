require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  
  it { should belong_to :linkable }

  describe 'check gist' do
    context 'with not gist link' do
      subject { Link.new(name: 'test', url: 'https://google.com') }
      it { is_expected.not_to be_gist }
    end

    context 'with gist link' do
      subject { Link.new(name: 'test', url: 'https://gist.github.com/Svawek/1fc1816264259cfa7c4e34ca19699aef') }
      it { is_expected.to be_gist}
    end
  end
end
