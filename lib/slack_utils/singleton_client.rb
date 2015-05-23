require 'slack'
require 'net/http'

module SlackUtils
  class SingletonClient
    CACHE_MAX_SIZE = 100

    # Get singleton client instance.
    # @return [SingletonClient] client.
    def self.instance
      @singleton_client_instance ||= new
    end

    # Initialize singleton client.
    def initialize
      @client = Slack::Client.new
    end

    # Get Slack Realtime API Client.
    # @return [Slack::RealTime::Client]
    def rtm_client
      @rtm_client ||=client.realtime
    end

    # Find Channel ID from name.
    # @note This method is slow.
    # @param [String] channel_name Name of channel.
    # @return [String, nil] ID of channel, Return nil when channel is not found.
    def find_channel_id(channel_name)
      channel = channels.find {|c| c['name'] == channel_name}
      if channel
        channel['id']
      else
        nil
      end
    end

    # Find Channel Name.
    # @param [String] channel_id ID of channel.
    # @return [String, nil] Name of channel, Return nil when channel is not found.
    def find_channel_name(channel_id)
      channel = resource(SlackUtils::Resources::CHANNEL, channel_id)
      if channel
        channel['name']
      else
        nil
      end
    end

    # Find User ID from name.
    # @note This method is slow.
    # @param [String] user_name Name of user.
    # @return [String, nil] ID of user, Return nil when user is not found.
    def find_user_id(user_name)
      user = users.find {|u| u['name'] == user_name}
      if user
        user['id']
      else
        nil
      end
    end

    # Find User Name.
    # @param [String] user_id ID of user.
    # @return [String, nil] Name of user, Return nil when user is not found.
    def find_user_name(user_id)
      user = resource(SlackUtils::Resources::USER, user_id)
      if user
        user['name']
      else
        nil
      end
    end

    # Join channel.
    # @param [String] channel_name Name of channel.
    # @return [Hash] result.
    def join_channel(channel_name)
      client.channels_join(name: channel_name)
    end

    # Invite channel.
    # @param [String] channel_id ID of channel.
    # @param [String] user_id    ID of user.
    # @param [String] token      Token of inviter.
    def invite_channel(channel_id, user_id, inviter_token)
      Net::HTTP.post_form(URI.parse('https://slack.com/api/channels.invite'), {channel: channel_id, user: user_id, token: inviter_token})
    end

    # Send message to channel.
    # @param [String] channel_id ID of channel.
    # @param [String] name       Name of user.
    # @param [String] icon_emoji Emoji of user.
    # @param [String] text       Message text.
    def send_message(channel_id, name, icon_emoji, text)
      client.chat_postMessage(username: name, channel: channel_id, text: text, icon_emoji: ":#{icon_emoji}:".squeeze(':'))
    end

    private
    # Get slack client.
    # @return [Slack::Client] client.
    def client
      @client
    end

    # Get Resource.
    # @param [SlackUtils::Resources] resource_type type of resource.
    # @param [String]                                  id            id of resource.
    # @return [Hash] information of resource.
    def resource(resource_type, id)
      type = resource_type.to_s.underscore
      Rails.cache.fetch("SingletonClient-#{type}-#{id}", expires_in: 15.minutes) do
        result = client.send("#{type.pluralize}_info", {type.to_sym => id})
        if result['ok']
          result[type]
        else
          nil
        end
      end
    end

    # Get all channels.
    # @return [Array<Hash>] channel list.
    def channels
      Rails.cache.fetch("SingletonClient-Channels", expires_in: 30) do
        result = client.channels_list
        if result['ok']
          result['channels']
        else
          []
        end
      end
    end

    # Get all users.
    # @return [Array<Hash>] user list.
    def users
      Rails.cache.fetch("SingletonClient-Users", expires_in: 30) do
        result = client.users_list
        if result['ok']
          result['members']
        else
          []
        end
      end
    end

    private_class_method :new
  end
end
