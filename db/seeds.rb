# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  {
    name: 'cash',
  },
  {
    name: 'bank',
  },
  {
    name: 'credit_card',
  },
  {
    name: 'e-money',
  },
  {
    name: 'point',
  },
  {
    name: 'loan',
  },
  {
    name: 'other_asset',
  },
  {
    name: 'other_debt',
  },
].each do |r|
  AssetType.find_or_create_by!(r)
end

[
  {
    name: 'any_time',
  },
  {
    name: 'daily',
  },
  {
    name: 'weekly',
  },
  {
    name: 'monthly',
  },
  {
    name: 'yearly',
  },
].each do |r|
  SimulationEntryType.find_or_create_by!(r)
end
