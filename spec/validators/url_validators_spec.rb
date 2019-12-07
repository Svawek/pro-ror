require 'rails_helper'

RSpec.describe UrlValidator, type: :model do
  describe 'url validation' do
    before { @validator = UrlValidator.new attributes: { url: '' } } 
  
    context 'invalid input' do
      it 'should return false for a poorly formed URL' do
        link = Link.new(name: 'test', url: 'something.com')
        expect(@validator).not_to be_url_valid(link.url)
      end
  
      it 'should return false for garbage input' do
        link = Link.new(name: 'test', url: 3.14159265)
        expect(@validator).not_to be_url_valid(link.url)
      end
  
      it 'should return false for URLs without an HTTP protocol' do
        link = Link.new(name: 'test', url: 'ftp://secret-file-stash.net')
        expect(@validator).not_to be_url_valid(link.url)
      end
    end
  
    context 'valid input' do
      it 'should return true for a correctly formed HTTP URL' do
        link = Link.new(name: 'test', url: 'http://nooooooooooooooo.com')
        expect(@validator).to be_url_valid(link.url)
      end
  
      it 'should return true for a correctly formed HTTPS URL' do
        link = Link.new(name: 'test', url: 'https://google.com')
        expect(@validator).to be_url_valid(link.url)
      end
    end
  end
end
