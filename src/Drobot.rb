# -*- coding: utf-8 -*-
require "cinch"

require_relative "joinpart"
require_relative "JD"

# Create the bot
drobot = Cinch::Bot.new do
  configure do |c|
    c.nick = "Drobot"
    c.server = "irc.nebula.fi"
    c.channels = ["#asdfoj"]
    c.plugins.plugins = [JoinPart, JD]
    c.plugins.prefix = lambda{ |m| Regexp.new("^" + Regexp.escape(m.bot.nick + ": " ))}
  end
end

# Run the bot
drobot.start
