class LineNotificationJob < ApplicationJob
  queue_as :default

  def perform(line_uid, message)
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_BOT_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_BOT_CHANNEL_TOKEN']
    }

    response = client.push_message(line_uid, message)
    p response
  end
end
