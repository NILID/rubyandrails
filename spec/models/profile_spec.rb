require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile) { build(:profile) }

  context 'should' do
    it 'have user' do
      profile.user = nil
      expect(profile.valid?).to be false
      expect(profile.errors[:user]).not_to be_empty
    end
  end
end
