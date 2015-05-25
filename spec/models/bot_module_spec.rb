require 'rails_helper'

RSpec.describe BotModule, type: :model do
  fixtures :bots
  fixtures :bot_modules
  fixtures :users

  let :bot_module do
    BotModule.find(1)
  end

  describe '#name' do
    it 'Presence' do
      expect(bot_module).to validate_presence_of(:name)
    end

    it 'Length Range in 1,32' do
      expect(bot_module).to validate_length_of(:name).is_at_least(1).is_at_most(32)
    end
  end

  describe '#description' do
    it 'Length Range in 0,128' do
      expect(bot_module).to validate_length_of(:description).is_at_most(128)
    end
  end

  describe '#user' do
    it 'Presence' do
      expect(bot_module).to validate_presence_of(:user)
    end
  end

  describe '#script' do
    it 'Presence' do
      expect(bot_module).to validate_presence_of(:script)
    end

    it 'Length Range in 1,64kb' do
      expect(bot_module).to validate_length_of(:script).is_at_least(1).is_at_most(64.kilobytes)
    end
  end
end
