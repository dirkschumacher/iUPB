# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Restaurant.delete_all
Restaurant.create({ name: 'Mensa', feed_url:'http://www.studentenwerk-pb.de/fileadmin/xml/mensa.xml' })
Restaurant.create({ name: 'Gownsmen Pub', feed_url:'http://www.studentenwerk-pb.de/fileadmin/xml/gownsmenspub.xml'  })
Restaurant.create({ name: 'Palmengarten', feed_url:'http://www.studentenwerk-pb.de/fileadmin/xml/palmengarten.xml'  })