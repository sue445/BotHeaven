require 'rails_helper'

RSpec.describe BotBotModule, type: :model do
  fixtures :bots
  fixtures :bot_modules
  fixtures :bot_bot_modules


  let :bot_bot_module do
    BotBotModule.find(1)
  end

  describe '#bot' do
    it 'Presence' do
      expect(bot_bot_module).to validate_presence_of(:bot)
    end
  end

  describe '#bot_module' do
    it 'Presence' do
      expect(bot_bot_module).to validate_presence_of(:bot_module)
    end
  end
end
