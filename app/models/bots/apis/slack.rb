module Bots::Apis
  # AlarmAPI class of Bot.
  class Slack
    # Initialize class.
    # @param [Bot] bot instance of bot.
    def initialize(bot)
      @bot = bot
    end

    # Talk
    # @param [String] message message.
    # @return [Boolean] true if success.
    def talk(message)
      talk_with_icon(message, @bot.default_icon)
    end

    # Talk with icon
    # @param [String] message     message.
    # @param [String] icon_emoji emoji icon.
    # @return [Boolean] true if success.
    def talk_with_icon(message, icon_emoji)
      JobDaemon.enqueue(JobDaemons::SlackTalkJob.new(@bot.channel_id.to_s, @bot.name.to_s, icon_emoji.to_s, message.to_s))
      true
    rescue
      false
    end
  end
end
