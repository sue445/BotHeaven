module Bots
  # API class of Bot.
  class Permissions < Inum::Base
    define :PRIVATE_BOT, 0
    define :PUBLIC_BOT,  1
    define :FREEDOM_BOT, 2
  end
end
