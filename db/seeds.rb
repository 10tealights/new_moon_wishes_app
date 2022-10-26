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

Tag.create!(
  [
    { id: 1, name: '人生' },
    { id: 2, name: '仕事' },
    { id: 3, name: '人間関係' },
    { id: 4, name: '勉強' },
    { id: 5, name: '恋愛' },
    { id: 6, name: 'パートナーシップ' },
    { id: 7, name: 'セクシャリティ' },
    { id: 8, name: '家庭' },
    { id: 9, name: '生活' },
    { id: 10, name: '健康' },
    { id: 11, name: 'お金' },
    { id: 12, name: '趣味' },
    { id: 13, name: 'ダイエット' },
    { id: 14, name: 'マインド' }
  ]
)

CSV.foreach('db/csv/traits.csv', headers: true) do |row|
  Trait.create!(
    keyword: row['keyword'],
    zodiac_sign_id: row['zodiac_sign_id']
  )
end