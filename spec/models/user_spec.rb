require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users

  let :user do
    User.find(1)
  end

  describe '#uid' do
    it 'Presence' do
      expect(user).to validate_presence_of(:uid)
    end

    it 'Uniqueness' do
      expect(user).to validate_uniqueness_of(:uid)
    end

    it 'Length Range in 1,128' do
      expect(user).to validate_length_of(:uid).is_at_least(1).is_at_most(128)
    end
  end

  describe '#name' do
    it 'Length Range in 0,128' do
      expect(user).to validate_length_of(:name).is_at_most(128)
    end
  end

  describe '#image_url' do
    it 'Length Range in 0,128' do
      expect(user).to validate_length_of(:image_url).is_at_most(512)
    end
  end

  describe '#find_or_create' do
    let :uid do
      user.uid
    end

    subject do
      User.find_or_create!(uid)
    end

    it 'Return User.' do
      expect(subject).to eq(user)
    end

    context 'When not existing uid' do
      let :uid do
        'ahahaha!'
      end

      it 'Return User.' do
        expect(subject).not_to be_nil
      end

      it 'Create new user.' do
        expect {
          subject
        }.to change(User, :count).by(1)
      end
    end
  end
end
