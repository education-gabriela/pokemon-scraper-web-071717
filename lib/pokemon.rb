class Pokemon
  attr_accessor :name, :type, :db, :id
  FIELDS = [:id, :name, :type]

  def initialize(args)
    args.each {|key, value| self.send("#{key}=", value)}
  end

  # Creates a pokemon object from the database result array
  def self.create_from_array(pokemon_array, db)
    pokemon_hash = Hash[pokemon_array.map.with_index { |pokemon_array_value, i|
      [FIELDS[i], pokemon_array_value]
    }]

    pokemon_hash[:db] = db
    self.new(pokemon_hash)
  end

  def self.save(name, type, db)
    statement = db.prepare "INSERT INTO pokemon (name, type) VALUES (:name, :type)"
    statement.execute name, type
  end

  def self.find(id, db)
    statement = db.prepare "SELECT * FROM pokemon WHERE id = :id"
    result = statement.execute id

    self.create_from_array(result.first, db)
  end
end
