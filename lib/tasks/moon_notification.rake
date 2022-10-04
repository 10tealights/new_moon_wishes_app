namespace :moon_notification do
  desc 'New-moon-wishesのLINEBotにて新月の通知'
  task :push_line_message => :environment do
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_BOT_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_BOT_CHANNEL_TOKEN']
    }

    # Test送信
    target_user = User.preload(:authentications).find('61d37e98-6c51-4e08-8ac4-6f717bbceecb')
    # target_users.each do |user|
      message = {
        type: 'text',
        text: "#{target_user.name}さん、今日は新月です。願いごとを宣言してみませんか？https://new-moon-wishes.herokuapp.com"
      }
      line_uid = target_user.authentications.find_by(provider: 'line').uid
      response = client.push_message(line_uid, message)
      p response
    # end
  end
end
