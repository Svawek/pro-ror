require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  
  it { should belong_to :linkable }

  describe 'url validation' do
    before { @link = UrlValidator.new attributes: { url: '' } } 
  
    context 'invalid input' do
      it 'should return false for a poorly formed URL' do
        expect(@link.url_valid?('something.com')).to be_falsey
      end
  
      it 'should return false for garbage input' do
        pi = 3.14159265
        expect(@link.url_valid?(pi)).to be_falsey
      end
  
      it 'should return false for URLs without an HTTP protocol' do
        expect(@link.url_valid?('ftp://secret-file-stash.net')).to be_falsey
      end
    end
  
    context 'valid input' do
      it 'should return true for a correctly formed HTTP URL' do
        expect(@link.url_valid?('http://nooooooooooooooo.com')).to be_truthy
      end
  
      it 'should return true for a correctly formed HTTPS URL' do
        expect(@link.url_valid?('https://google.com')).to be_truthy
      end
    end
  end
end
