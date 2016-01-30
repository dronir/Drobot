# -*- coding: utf-8 -*-
require "cinch"
require "toml"

require_relative "joinpart"
require_relative "JD"
require_relative "whatis"

CONFIG = TOML.load_file("config.toml")

# Create the bot
drobot = Cinch::Bot.new do
  configure do |c|
    c.nick = CONFIG["nick"]
    c.server = CONFIG["server"]
    c.channels = CONFIG["channels"]
    c.plugins.plugins = [JoinPart, WhatIs, JD]
    c.whatis_db_path = CONFIG["WhatIs"]["db_path"]
  end
end

# Run the bot
drobot.start
