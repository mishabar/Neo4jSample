# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


neo = Neography::Rest.new(ENV['NEO4J_URL'] || "http://localhost:7474")

neo.execute_script("g.clear();")

neo.set_node_auto_index_status(true)
neo.create_node_auto_index
neo.add_node_auto_index_property('_type')
neo.add_node_auto_index_property('id')

userNodes = {}
artistNodes = {}

$stdout << "\nReading Users\n"
File.open(File.expand_path('db/users.dat')).readlines.map do |l|
  (id, name) = l.strip.split('::')
  userNodes[id.to_i] = neo.create_node({ "_type" => 'User', "id" => 'user' + id , 'name' => name })
  $stdout << "."
end

$stdout << "\nReading Artists\n"
File.open(File.expand_path('db/artists.dat')).readlines.map do |l|
  (id, name) = l.strip.split('::')
  artistNodes[id.to_i] = neo.create_node({ "_type" => 'Artist', "id" => 'artist' + id , 'name' => name })
  $stdout << "."
end

$stdout << "\nReading Favors Relations\n"
File.open(File.expand_path('db/favors.dat')).readlines.map do |l|
  (uid, aid) = l.strip.split('::')
  neo.create_relationship('favors', userNodes[uid.to_i], artistNodes[aid.to_i])
  $stdout << "."
end