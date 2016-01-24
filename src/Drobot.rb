# -*- coding: utf-8 -*-
require "cinch"

require_relative "joinpart"

SERVER = ARGV[0]

# Create the bot
drobot = Cinch::Bot.new do
  configure do |c|
    c.nick = "Drobot"
    c.server = SERVER
    c.channels = ["#asdfoj"]
    c.plugins.plugins = [JoinPart]
  end
end

# Run the bot
drobot.start
