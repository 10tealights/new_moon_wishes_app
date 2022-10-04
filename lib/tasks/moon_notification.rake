namespace :moon_notification do
  desc 'New-moon-wishesのLINEBotにて新月の通知'
  task :push_line_message => :environment do
    # 抽出する新月は後で修正
    target_users = Moon.find(1).wished_users.preload(:authentications).where(need_newmoon_msg: :true)
    target_users.each do |user|
      message = {
        type: 'text',
        text: "#{user.name}さん、今日は新月です。願いごとを宣言してみませんか？https://new-moon-wishes.herokuapp.com"
      }
      line_uid = user.authentications.find_by(provider: 'line').uid
      LineNotificationJob.perform_later(line_uid, message)
    end
  end
end
