class WhatIs
  include Cinch::Plugin
  require 'date'
  require 'sqlite3'

  def initialize(*)
    super
    begin
      @db = SQLite3::Database.open bot.config.whatis_db_path
      @db.results_as_hash = true
      @status = true
    rescue SQLite3::Exception => e
      puts "Problem connecting to WhatIs database!"
      puts e
      @status = false
      @db.close if @db
    end
  end

  set :prefix, /^/

  # Regex for whatis query
  match /(w|!whatis)?\s+([^S]+)/, method: :whatis_query
  
  # Regex for definition
  match /!define ([\S]+)\s+(.+)/, method: :definition
  
  # Regex for whodef
  match /!whodef\s+(\w+)\s+([0-9]+)/, method: :whodef
  
  
  def whatis_query(event, sufx, query)
    synchronize(:define_db_access) do
      user = event.user.nick
      begin
        stm = @db.prepare "SELECT * FROM entries WHERE key = :query"
        rs = stm.execute query
        i = 0
        rs.each do |row|
          i += 1
          key = row["key"]
          value = row["definition"]
          event.channel.msg("#{key} (#{i}): #{value}")
          sleep 0.5  
        end
      rescue SQLite3::Exception => e
        event.channel.msg("Something went wrong.")
      end
    end
  end
  

  def definition(event, key, value)
    synchronize(:define_db_access) do
      user = event.user.nick
      begin
        stm = @db.prepare "insert into entries (key, definition, definer) values (:key, :value, :user)"
        stm.execute key, value, user      
        event.channel.msg("#{user}: Definition added.")
      rescue SQLite3::Exception => e
        event.channel.msg("#{user}: Something went wrong.")
        puts "Something went wrong: #{user}: #{key} = #{value}"
        puts e
      end
    end    
  end
  
  def whodef(event, key, index)
  end
  
end
