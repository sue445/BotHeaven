# class of Bot.
# @attr [Integer]           id            Bot ID.
# @attr [String]            name          Name of bot.
# @attr [String]            channel       Channel Name of bot.
# @attr [String]            channel_id    ID of channel.
# @attr [User]              user          Author of bot.
# @attr [String]            default_icon  Default Icon of bot.
# @attr [String]            script        Script of bot.
# @attr [String]            current_error Current Error of bot. When bot does not have error, This value is Empty.
# @attr [Bots::Permissions] permission    Permission of bot.
class Bot < ActiveRecord::Base
  SCRIPT_TIMEOUT = 1000

  after_create :create_default_storage
  before_save :set_channel_id

  belongs_to :user,    inverse_of: :bots
  has_one :storage, inverse_of: :bot
  has_many :alarms, inverse_of: :bot
  has_many :bot_bot_modules, inverse_of: :bot
  has_many :bot_modules, through: :bot_bot_modules

  bind_inum :permission, Bots::Permissions

  validates :name,         presence: true, length: {in: 1..32}, format: {with: /\A[A-Za-z0-9_-]+\Z/}
  validates :channel,      presence: true, length: {in: 1..32}, format: {with: /\A[A-Za-z0-9_-]+\Z/}
  validates :user,         presence: true
  validates :default_icon, length: {maximum: 32}, format: {with: /\A\w*\Z/}
  validates :script,       presence: true, length: {in: 1..64.kilobytes}

  # Execute Function of bot script.
  # @param [String] function name of function.
  # @param [Array]  arguments.
  # @return [String] eval of function.
  def execute_function(function, arguments: [])
    cxt = V8::Context.new(timeout: SCRIPT_TIMEOUT)
    cxt['api'] = Bots::API.new(self)
    cxt.eval self.script
    cxt['bot_function_params'] = arguments
    cxt.eval("#{function}.apply(this, bot_function_params)").to_s
  rescue => e
    update_column(:current_error, "#{Time.zone.now} - #{e.to_s}")
    nil
  ensure
    cxt.dispose unless cxt.nil?
  end

  # Get Channel ID.
  # @return [String] ID of channel.
  def channel_id
    cid = super
    if cid.present?
      cid
    else
      SlackUtils::SingletonClient.instance.find_channel_id(channel).tap do |cid|
        update_column(:channel_id, cid) if cid
      end
    end
  end

  # Check Owner.
  # @param [User] user
  # @return [Boolean] true if user is owner.
  def owner?(user)
    self.user == user
  end

  # Return Slack Bot ID.
  # @return [String] ID of SlackBot.
  def self.slack_bot_id
    if @slack_bot_id.present?
      @slack_bot_id
    else
      @slack_bot_id = SlackUtils::SingletonClient.instance.find_user_id(
          Rails.application.secrets.slack_bot_name
      )
    end
  end

  private
  # Set channel id.
  def set_channel_id
    self.channel_id = SlackUtils::SingletonClient.instance.find_channel_id(channel)
  end

  # Create bot storage.
  def create_default_storage
    create_storage!(content: '{}')
  end
end
