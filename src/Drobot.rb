# -*- coding: utf-8 -*-
require "cinch"

require_relative "joinpart"
require_relative "whatis"

SERVER = ARGV[0]

# Create the bot
drobot = Cinch::Bot.new do
  configure do |c|
    c.nick = "Drobot"
    c.server = SERVER
    c.channels = ["#asdfoj"]
    c.plugins.plugins = [JoinPart, WhatIs]
  end
end

# Run the bot
drobot.start
