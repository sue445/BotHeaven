require 'rails_helper'

RSpec.describe Storage, type: :model do
  fixtures :bots
  fixtures :users
  fixtures :storages

  let :storage do
    Storage.find(1)
  end

  describe '#bot' do
    it 'Presence' do
      expect(storage).to validate_presence_of(:bot)
    end
  end

  describe '#storage' do
    it 'Length Range in 0,128kb' do
      expect(storage).to validate_length_of(:content).is_at_least(0).is_at_most(128.kilobytes)
    end
  end
end
