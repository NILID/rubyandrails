require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) { build_stubbed(:url) }

  context 'should' do
    it 'have valid url' do
      url.url = 'site url'
      expect(url.valid?).to be false
      expect(url.errors[:url]).not_to be_empty
    end

    it 'have prefix in site' do
      url.url = 'google.ru'
      expect(url.valid?).to be false
      expect(url.errors[:url]).not_to be_empty
    end

    it 'have valid with good site' do
      url.url = 'https://google.ru'
      expect(url.valid?).to be true
      expect(url.errors).to be_empty
    end
  end
end
