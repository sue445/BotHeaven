module Bots::Apis
  # HTTP API class of Bot.
  class HTTP
    # Initialize class.
    # @param [Bot] bot instance of bot.
    def initialize(bot)
      @bot = bot
    end

    # Get request.
    # @param [String] url      URL.
    # @param [Hash]   params   Params.
    # @param [String] callback Name of callback.
    # @return [Boolean] true if success.
    def get(url, params, callback)
      create_job(:get, url, params, callback)
      true
    rescue
      false
    end

    # Post request.
    # @param [String] url      URL.
    # @param [Hash]   params   Params.
    # @param [String] callback Name of callback.
    # @return [Boolean] true if success.
    def post(url, params, callback)
      create_job(:post, url, params, callback)
      true
    rescue
      false
    end

    private
    # Create HTTP Request Job.
    # @param [Symbol] method   Method.(:get or :post)
    # @param [String] url      URL.
    # @param [Hash]   params   Params.
    # @param [String] callback Name of callback.
    def create_job(method, url, params, callback)
      JobDaemon.enqueue(
        JobDaemons::HTTPRequestJob.new(@bot.id, callback.to_s, method, url.to_s, Hash[params.to_a])
      )
    end
  end
end
