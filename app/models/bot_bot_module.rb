# Intermediate table
class BotBotModule < ActiveRecord::Base
  belongs_to :bot, inverse_of: :bot_bot_modules
  belongs_to :bot_module, inverse_of: :bot_bot_modules

  validates :bot,        presence: true
  validates :bot_module, presence: true
end
