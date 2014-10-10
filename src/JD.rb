
class JD
  include Cinch::Plugin
  
  match /JD +([0-9]+(\.[0.9]+)?)/, method: :JDtoDate
  match /JD( *\n| [0-9]+[\.\-][0-9]+[\.\-][0-9]+)/, method: :DatetoJD
  
  def DatetoJD(m, date_string)
    my_match = /([0-9]+)[\.\-]([0-9]+)[\.\-]([0-9]+)/.match(date_string)
    puts my_math.captures
    day = my_match[1].to_i
    month = my_match[2].to_i
    year = my_match[3].to_i
  end
  
  def JDtoDate(m, jd_string)
    s = m.user.nick
    j = jd_string.to_f - 0.25
    f = j + 1401 + ((4*j+274277).div(146097)*3).div(4) - 38
    e = 4*f + 3
    g = (e%1461).div(4)
    h = 5*g + 2
    day = (h % 153).div(5) + 1
    month = ((h.div(153) + 2) % 12) + 1
    year = e.div(1461) - 4716 + (14-month).div(12)
    m.channel.msg("#{s}: #{day}.#{month}.#{year}")
  end
end
