# class of User.
# @attr [Integer] id            ID of Bot heaven.
# @attr [String]  uid           UserID of Slack.
# @attr [String]  name          Name of user.
# @attr [String]  image_url     Image URL of user.
class User < ActiveRecord::Base
  has_many :bots, inverse_of: :user
  has_many :bot_modules, inverse_of: :user

  validates :uid,       length: {in: 1..128}, presence: true, uniqueness: true
  validates :name,      length: {maximum: 128}
  validates :image_url, length: {maximum: 512}

  # Find User of Create.
  # @param [String] uid UserID of Slack.
  # @return [User] User.
  def self.find_or_create!(uid)
    if user = User.find_by(uid: uid)
      user
    else
      User.create!(uid: uid)
    end
  end
end
