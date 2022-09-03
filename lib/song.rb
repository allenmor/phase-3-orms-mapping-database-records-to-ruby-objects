require 'pry'

class Song

  attr_accessor :name, :album, :id
  @@all = []

def initialize(name:, album:, id: nil)
  @name = name
  @album = album
  @id = id
  @@all << self
end

def self.all
  @@all
end

def self.create_table
  sql = <<-SQL
  create table if not exists songs(
    id integer primary key,
    name text,
    album text
  )
  SQL
  DB[:conn].execute(sql)
end

def save 
  sql = <<-SQL
  insert into songs(name, album)
  values(?, ?)
  SQL
  sql2 = <<-SQL
  SELECT MAX(id) FROM songs
  SQL
  DB[:conn].execute(sql, self.name, self.album)
  self.id = DB[:conn].execute(sql2)[0][0]
  self
end
# binding.pry

def self.create(name:, album:)
  new_song = Song.new(name: name, album: album)
  new_song.save 
end

def self.new_from_db(row)
  Song.new(id: row[0], name: row[1], album: row[2])
end

def self.all
  sql = <<-SQL
  select * from songs
  SQL
  DB[:conn].execute(sql).map{|el| Song.new_from_db(el)}
  # binding.pry
  
end

def self.find_by_name(name)
  sql = <<-SQL
  select * from songs
  where name = '#{name}'
  SQL
  yo = DB[:conn].execute(sql)
  Song.new_from_db(yo[0])
  # binding.pry
end



end












# attr_accessor :name, :album, :id

# def initialize(name:, album:, id: nil)
#   @name = name
#   @album =  album
#   @id =  id
# end

# def self.create_table
#   sql = <<-SQL
#   create table if not exists songs
#   (id integer primary key,
#   name text,
#   album text)
#   SQL
#   DB[:conn].execute(sql)
# end

# def save
#   sql = <<-SQL
#   insert into songs(name, album)
#   values(?, ?)
#   SQL
#   DB[:conn].execute(sql, @name, @album)
#   sql2 = <<-SQL
#   SELECT MAX(id) FROM songs
#   SQL
#   self.id = DB[:conn].execute(sql2)[0][0]
#   self
# end

# def self.create(name:, album:)
#   new_song = Song.new(name: name, album: album)
#   new_song.save
# end

# def self.new_from_db(row)
#   Song.new(id: row[0], name:row[1], album: row[2])
# end

# def self.all
#    sql = <<-SQL
#    select * from songs
#    SQL
#    DB[:conn].execute(sql).map{|el| Song.new_from_db(el)}
# end

# def self.find_by_name(name)
#   sql = <<-SQL 
#   select * from songs where name = '#{name}' 
#   SQL
#   test_equals = DB[:conn].execute(sql)[0]
#   Song.new_from_db(test_equals)

# end