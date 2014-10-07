require "cinch"

class JoinPart
  include Cinch::Plugin
  
  match /join (.+)/, method: :join
  
  set :prefix, lambda{ |m| Regexp.new("^" + Regexp.escape(m.bot.nick + ": " ))}
  
  def check_user(user)
    user.refresh
    user.match("*!dronir@kapsi.fi")
  end
  
  def join(m, channel)
    unless check_user(m.user)
      talk_back(m)
      return
    end
    Channel(channel).join
  end
  
  def talk_back(m)
    s = m.user.nick
    m.channel.msg("#{s}: Don't tell me what to do.")
  end
end
