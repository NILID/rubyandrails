require 'rails_helper'

# TODO
# add validates roles inclusion and check it

describe User do
  let(:user) { build(:user) }

  context 'should' do

    it 'have guest role by default for unreg user' do
      expect(user.roles).to eq(['guest'])
    end

    it 'have user role by default after create' do
      user.save!
      expect(user.roles).to eq(['user'])
    end

    it 'have many roles' do
      user.roles = %w[user admin]
      expect(user.valid?).to be true
      expect(user.errors).to be_empty
    end

    it 'have not login less 3' do
      user.login = 'ma'
      expect(user.valid?).to be false
      expect(user.errors[:login]).not_to be_empty
    end

    it 'have not login more 12' do
      user.login = 'm' * 13
      expect(user.valid?).to be false
      expect(user.errors[:login]).not_to be_empty
    end

    it 'have login' do
      user.login = nil
      expect(user.valid?).to be false
      expect(user.errors[:login]).not_to be_empty
    end

    it 'have not unique login' do
      user.save!
      new_user = build(:user)
      new_user.login = user.login
      expect(new_user.valid?).to be false
      expect(new_user.errors[:login]).not_to be_empty
    end

    it 'have not login with specific symbols' do
      ['log,in', 'my login', 'very-big', '<hello>'].each do |login|
        user.login = login
        expect(user.valid?).to be false
        expect(user.errors[:login]).not_to be_empty
      end
    end

    it 'have not login from blacklist' do
      LOGIN_BLACKLIST.each do |login|
        user.login = login
        expect(user.valid?).to be false
        expect(user.errors[:login]).not_to be_empty
      end
    end

    it 'have profile after create' do
      user.save!
      expect(user.profile).not_to be_nil
      expect(user.profile.valid?).to be true
    end
  end
end
