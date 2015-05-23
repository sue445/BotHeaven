module Bots::Apis
  # StorageAPI class of Bot.
  class Storage
    # Initialize class.
    # @param [Bot] bot instance of bot.
    def initialize(bot)
      @bot = bot
    end

    # Get value.
    # @param [String] key.
    # @return [String] value.
    def [](key)
      storage_hash[key.to_s]
    rescue
      nil
    end

    # Set data.
    # @param [String] key   key.
    # @param [String] value value.
    # @return [Boolean] true if success.
    def []=(key, value)
      storage_hash.tap do |storage|
        storage[key.to_s] = value.to_s
        @bot.storage.update!(content: storage.to_json)
      end
      true
    rescue
      false
    end

    # Get keys of storage data.
    # @return [Array<String>] keys.
    def keys
      storage_hash.keys
    rescue
      nil
    end

    # Clear Storage.
    # @note This argument is necessary to recognize it to be a function.
    # @return [Boolean] true if success.
    def clear(dummy=true)
      @bot.storage.update!(content: '{}')
      true
    rescue
      false
    end

    private
    # Get storage of hash format.
    # @return [Hash] storage data.
    def storage_hash
      JSON.parse(@bot.storage.reload.content || '{}')
    end
  end
end
