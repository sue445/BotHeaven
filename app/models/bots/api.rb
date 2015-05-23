module Bots
  # API class of Bot.
  class API
    API_VERSION = '0.0.1'

    # Initialize class.
    # @param [Bot] bot instance of bot.
    def initialize(bot)
      @bot = bot
    end

    # Get API Version.
    # @return [String] version.
    def version
      API_VERSION
    end

    # Get Alarm API.
    # @return [Bots::Apis::Alarm] alarm api.
    def alarm
      @alarm ||= Bots::Apis::Alarm.new(@bot)
    end

    # Get HTTP API.
    # @return [Bots::Apis::HTTP] slack api.
    def http
      @http ||= Bots::Apis::HTTP.new(@bot)
    end

    # Get Slack API.
    # @return [Bots::Apis::Slack] slack api.
    def slack
      @slack ||= Bots::Apis::Slack.new(@bot)
    end

    # Get Storage API.
    # @return [Bots::Apis::Storage] storage api.
    def storage
      @storage ||= Bots::Apis::Storage.new(@bot)
    end
  end
end
