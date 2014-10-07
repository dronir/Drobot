require "cinch"

# Create the bot
drobot = Cinch::Bot.new do
  configure do |c|
    c.nick = "Drobot"
    c.server = "irc.nebula.fi"
    c.channels = ["#asdfoj"]
  end
end

# Run the bot
drobot.start
