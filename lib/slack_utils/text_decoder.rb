module SlackUtils
  # Text decoder of Slack.
  class TextDecoder
    # Decode Slack Text.
    # @param [String] text text.
    # @return [String] decoded text.
    def self.decode(text)
      decoded_text = text.gsub(/<[^>]+>/) do |slack_escaped_string|
        identifier = slack_escaped_string.slice(1, 1)
        content = slack_escaped_string.slice(2, slack_escaped_string.length - 3)

        case identifier
        when '@'
          SlackUtils::SingletonClient.instance.find_user_name(content)
        when '#'
          SlackUtils::SingletonClient.instance.find_user_name(content)
        else
          content
        end
      end
      CGI.unescapeHTML(decoded_text)
    end
  end
end
