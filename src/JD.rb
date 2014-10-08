
class JD
  include Cinch::Plugin
  
  match /JD +([0-9]+(\.[0.9]+)?)/, method: :JDtoDate
  #match /JD( [0-9]+.[0-9]+.[0.9]+)?/, method :DatetoJD
  
  def JDtoDate(m, jd_string)
    s = m.user.nick
    unless jd_string
      m.channel.msg("#{s}: I didn't understand your number.")
      return
    end
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
