# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Country.create(
  [
    {name: 'Switzerland', iso_code2: 'CH'},
    {name: 'France', iso_code2: 'FR'},
    {name: 'United Kingdom', iso_code2:'GB'}
  ]
)
