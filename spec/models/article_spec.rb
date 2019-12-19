require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { build(:article) }

  context 'should' do
    it 'have hidden status by default' do
      article.save!
      expect(article.statuses_mask).to eq(1)
    end

    it 'have title' do
      article.title = nil
      expect(article.valid?).to be false
      expect(article.errors[:title]).not_to be_empty
    end

    it 'have content' do
      article.content = nil
      expect(article.valid?).to be false
      expect(article.errors[:content]).not_to be_empty
    end

    it 'have user or nil' do
      article.user = nil
      expect(article.valid?).to be true
      expect(article.errors[:user]).to be_empty
    end
  end
end
