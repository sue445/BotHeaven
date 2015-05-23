module JobDaemons
  # Bot job.
  class BotJob < JobBase
    attr_reader :bot_id, :function, :arguments

    # Initialize Job.
    # @param [Integer] bot_id    ID of bot.
    # @param [String]  function  Name of function.
    # @param [Array]   arguments Arguments of function.
    def initialize(bot_id, function, arguments)
      raise 'bot_id should be kind of Integer' unless bot_id.kind_of?(Integer)
      raise 'function should be kind of String' unless function.kind_of?(String)
      raise 'arguments should be kind of Array' unless arguments.kind_of?(Array)

      @bot_id = bot_id
      @function = function
      @arguments = arguments
    end

    # Execute Bot Job.
    def execute!
      Bot.find_by(id: @bot_id).execute_function(@function, arguments: @arguments)
    end
  end
end
