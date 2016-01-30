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
  match /(!?w|!whatis|!wtf)\s+([^S]+)/, method: :whatis_query
  
  # Regex for definition
  match /!define\s+([\S]+)\s+(.+)/, method: :definition
  
  # Regex for whodef
  match /!whodef\s+(\w+)\s+([0-9]+)/, method: :whodef
  
  # Regex for dick
  match /!?dick\s+([^S]+)/, method: :dick
    
  def whatis_query(event, sufx, query)
    synchronize(:define_db_access) do
      user = event.user.nick
      query = query.downcase
      begin
        stm = @db.prepare "SELECT * FROM entries WHERE key = :query"
        rs = stm.execute query
        i = 0
        
        all_rows = []
        rs.each do 
          |row| all_rows << row 
        end
        
        if all_rows.length > 10
          event.channel.msg("#{user}: Too many definitions: see http://dronir.xyz/whatis/#{query}")
          return
        end
        
        all_rows.each do |row|
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
        key = key.downcase
        stm = @db.prepare "insert into entries (key, definition, definer) values (:key, :value, :user)"
        stm.execute key, value, user      
        event.user.notice("Definition added.")
      rescue SQLite3::Exception => e
        event.user.notice("Something went wrong.")
        puts "Something went wrong: #{user}: #{key} = #{value}"
        puts e
      end
    end    
  end
  
  def whodef(event, query, index)
    index = index.to_i
    return unless index >= 1
    synchronize(:define_db_access) do
      user = event.user.nick
      query = query.downcase
      begin
        stm = @db.prepare "SELECT * FROM entries WHERE key = :query"
        rs = stm.execute query
        i = 0
        
        all_rows = []
        rs.each do 
          |row| all_rows << row 
        end
        
        if index > all_rows.length
          event.channel.msg("#{user}: '#{query}' only has #{all_rows.length} definitions.")
          return
        end
        
        who = all_rows[index]["definer"]
        time = all_rows[index]["timestamp"]
        
        event.channel.msg("#{user}: #{who} at #{time}.")
      end
    end
  end
  
  def dick(event, query)
    synchronize(:define_db_access) do
      user = event.user.nick
      query = query.downcase
      begin
        stm = @db.prepare "SELECT * FROM entries WHERE key = :query"
        rs = stm.execute query
        i = 0
        
        all_rows = []
        rs.each do 
          |row| all_rows << row 
        end
        
        event.channel.msg("#{user}: '#{query}' has #{all_rows.length} definitions.")
      end
    end
  end
  
end
