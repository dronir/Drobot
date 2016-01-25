
class JD
  include Cinch::Plugin
  require "date"
  
  set :prefix, lambda{ |m| Regexp.new("^" + Regexp.escape(m.bot.nick + ": " ))}
  
  # JD to date regex
  match /JD +([0-9]+(\.[0-9]+)?[\W]*$)/, method: :JDtoDate
  
  # Date to JD regex
  match /JD ([0-9]+[\-\.][0-9]+[\-\.][0-9]+)/, method: :DatetoJD
  
  match /JD[\W]*$/, method: :JDNow
    
  # Convert JD to a date
  def JDtoDate(event, jd_string)
    user = event.user.nick
    puts jd_string
    j = jd_string.to_f - 0.25
    f = j + 1401 + ((4*j+274277).div(146097)*3).div(4) - 38
    e = 4*f + 3
    g = (e%1461).div(4)
    h = 5*g + 2
    day = (h % 153).div(5) + 1
    month = ((h.div(153) + 2) % 12) + 1
    year = e.div(1461) - 4716 + (14-month).div(12)
    event.channel.msg("#{user}: #{day}.#{month}.#{year}")
  end
  
  # Convert a date to JD
  def DatetoJD(event, date_string)
    my_match = /([0-9]+)[\.\-]([0-9]+)[\.\-]([0-9]+)/.match(date_string)
    puts my_match.captures
    day = my_match[1].to_i
    month = my_match[2].to_i
    year = my_match[3].to_i
    a = ((14-month)/12.0).floor
    y = year + 4800.0 - a
    m = month + 12*a - 3.0
    j = day + ((153*m+2)/5).floor + 365*y + (y/4).floor - (y/100).floor + (y/400).floor - 32045
    user = event.user.nick
    event.channel.msg("#{user}: #{j}")
  end
  
  def JDNow(event)
    now = DateTime.now
    time_string = now.strftime("%d-%m-%Y")
    DatetoJD(event, time_string)
  end
  
end
