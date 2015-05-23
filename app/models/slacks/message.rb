module Slacks
  class Message
    attr_accessor :channel_id, :user_id, :raw_text, :ts

    # Initialize class.
    # @param [Hash] raw_message raw message of slack.
    def initialize(raw_message)
      @channel_id = raw_message['channel']
      @user_id    = raw_message['user']
      @raw_text   = raw_message['text']
      @ts         = raw_message['ts']
      @sub_type   = raw_message['subtype']
    end

    # Is bot message?
    # @return [Boolean] true if bot.
    def bot?
      @sub_type == 'bot_message' || @user_id.nil?
    end

    # Get Name of channel.
    # @return [String] Name of channel.
    def channel_name
      @channel_name ||= SlackUtils::SingletonClient.instance.find_channel_name(@channel_id)
    end

    # Get Name of user.
    # @return [String] Name of user.
    def user_name
      @user_name ||= SlackUtils::SingletonClient.instance.find_user_name(@user_id)
    end

    # Get Text.
    # @return [String] Text.
    def text
      @text ||= SlackUtils::TextDecoder.decode(@raw_text || '')
    end
  end
end
