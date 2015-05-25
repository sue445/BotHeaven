# Module of Bot.
# @attr [String]                   name        Name of Module.
# @attr [String]                   description Description of Module.
# @attr [String]                   script      Script of Module.
# @attr [User]                     user        Author of Module.
# @attr [BotModules::Permissions]  permission  Permission of Module.
class BotModule < ActiveRecord::Base
  belongs_to :user, inverse_of: :bot_modules
  has_many :bot_bot_modules, inverse_of: :bot_module
  has_many :bots, through: :bot_bot_modules

  bind_inum :permission, BotModules::Permissions

  validates :name,        length: {in: 1..32}, presence: true
  validates :description, length: {maximum: 128}
  validates :script,      length: {in: 1..64.kilobytes}, presence: true
  validates :user,        presence: true

  # Check if usable Module
  # @param [User] user
  def usable?(user)
    owner?(user) || permission == BotModules::Permissions::PUBLIC_MODULE
  end

  # Check if owner.
  # @param [User] user
  # @return [Boolean] true if user is owner.
  def owner?(user)
    self.user == user
  end
end
