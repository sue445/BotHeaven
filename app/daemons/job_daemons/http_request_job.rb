require 'net/http'

module JobDaemons
  # HTTP Request Job.
  class HTTPRequestJob < JobBase
    attr_reader :bot_id, :callback, :method, :url, :params

    # Initialize Job.
    # @param [Integer] bot_id   ID of bot.
    # @param [String]  callback function name of callback.
    # @param [Symbol]  method   Method of HTTP.
    # @param [String]  url      URL.
    # @param [Hash]    params   Parameters..
    def initialize(bot_id, callback, method, url, params)
      raise 'bot_id should be kind of Integer' unless bot_id.kind_of?(Integer)
      raise 'callback should be kind of String' unless callback.kind_of?(String)
      raise 'method should be :get or :post.' unless [:get, :post].include?(method)
      raise 'url should be kind of String' unless url.kind_of?(String)
      raise 'params should be kind of Hash' unless params.kind_of?(Hash)

      @bot_id = bot_id
      @callback = callback
      @method = method
      @url = url
      @params = params
    end

    # Execute HTTP Request Job.
    def execute!
      Thread.new do
        begin
          JobDaemon.enqueue(BotJob.new(@bot_id, @callback, [request]))
        rescue => e
          Rails.logger.error(e)
          e.backtrace.each {|l| Rails.logger.error(l)}
        end
      end
    end

    private
    # Request.
    # @return [String] Response body.
    def request
      uri = URI.parse(@url)
      case @method
      when :get
        uri.query = URI.encode_www_form(@params)
        Net::HTTP.get(uri)
      when :post
        Net::HTTP.post_form(uri, @params).body
      end
    end
  end
end
