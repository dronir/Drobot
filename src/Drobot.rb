# -*- coding: utf-8 -*-
require "cinch"

require_relative "joinpart"

# Create the bot
drobot = Cinch::Bot.new do
  configure do |c|
    c.nick = "Drobot"
    c.server = "irc.nebula.fi"
    c.channels = ["#asdfoj"]
    c.plugins.plugins = [JoinPart]
  end
end

# Run the bot
drobot.start
