require 'csv'

12.times do |n|
  ZodiacSign.create!(name: n)
end

CSV.foreach('db/csv/moons.csv', headers: true) do |row|
  Moon.create!(
    newmoon_time: row['newmoon_time'],
    zodiac_sign_id: row['zodiac_sign_id'],
    fullmoon_time: row['fullmoon_time']
  )
end
