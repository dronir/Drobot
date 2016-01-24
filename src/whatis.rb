class WhatIs
  include Cinch::Plugin

  set :prefix, lambda{ |m| Regexp.new("^" + Regexp.escape(m.bot.nick + ": " ))}

  match /w(hatis|tf)? ([^S]+)/, method: :whatis_query
  
  def whatis_query(event, sufx, query)
    user = event.user.nick
    event.channel.msg("#{user}: I don't yet know what #{(query)} is.")
  end
  
end
