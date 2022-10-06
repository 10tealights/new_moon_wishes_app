namespace :moon_notification do
  desc 'LINEBotにて新月・満月のプッシュ通知'
  task :push_line_message => :environment do
    newmoon = Moon.preload(:zodiac_sign).find_by(newmoon_time: Time.current.all_day)
    fullmoon = Moon.preload(:zodiac_sign).find_by(fullmoon_time: Time.current.all_day)

    if newmoon.present?
      target_users = User.preload(:authentications).where(need_newmoon_msg: :true)
      send_line_notifications(target_users, newmoon, '新月') if target_users.present?
    elsif fullmoon.present?
      target_users = fullmoon.wished_users.preload(:authentications).where(need_fullmoon_msg: :true)
      send_line_notifications(target_users, fullmoon, '満月') if target_users.present?
    else
      p '該当なし'
    end
  end

  def send_line_notifications(target_users, moon, moon_type)
    target_users.each do |user|
      message = {
        type: 'flex',
        altText: "#{moon.zodiac_sign.name_i18n}#{moon_type}のお知らせ",
        contents: flex_message(user, moon, moon_type)
       }
      line_uid = user.authentications.find_by(provider: 'line').uid
      LineNotificationJob.perform_later(line_uid, message)
    end
  end

  # 画像は後で差し替え予定
  def flex_message(user, moon, moon_type)
    {
      "type": "bubble",
      "hero": {
        "type": "image",
        "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/01_1_cafe.png",
        "size": "full",
        "aspectRatio": "16:9",
        "aspectMode": "cover",
        "action": {
          "type": "uri",
          "uri": "https://new-moon-wishes.herokuapp.com/"
        }
      },
      "body": {
        "type": "box",
        "layout": "vertical",
        "contents": [
          {
            "type": "text",
            "text": "#{moon_type}をお知らせします",
            "weight": "bold",
            "size": "lg",
            "align": "center"
          },
          {
            "type": "box",
            "layout": "vertical",
            "margin": "lg",
            "spacing": "sm",
            "contents": [
              {
                "type": "box",
                "layout": "baseline",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "text",
                    "text": text_content(user, moon, moon_type),
                    "wrap": true,
                    "color": "#666666",
                    "size": "sm",
                    "flex": 5,
                    "align": "center"
                  }
                ]
              }
            ]
          }
        ]
      },
      "footer": {
        "type": "box",
        "layout": "vertical",
        "spacing": "sm",
        "contents": [
          {
            "type": "button",
            "style": "link",
            "height": "sm",
            "action": {
              "type": "uri",
              "label": "#{moon_type.include?('新月') ? '願いごとを宣言する' : '願いごとを振り返る'}",
              "uri": "#{moon_type.include?('新月') ? 'https://new-moon-wishes.herokuapp.com/wishes/new' : 'https://new-moon-wishes.herokuapp.com/wishes'}"
            }
          },
          {
            "type": "box",
            "layout": "vertical",
            "contents": [],
            "margin": "sm"
          }
        ],
        "flex": 0
      }
    }
  end

  def text_content(user, moon, moon_type)
    if moon_type == '新月'
      content = "#{user.name}さん、おはようございます。今日は#{I18n.l(moon.newmoon_time, format: :only_time)}に#{moon.zodiac_sign.name_i18n}で#{moon_type}を#{moon.newmoon_time < Time.current ? '迎えました' : '迎えます'}。新月から48時間以内に願いごとを宣言してみませんか？"
    elsif moon_type == '満月'
      content = "#{user.name}さん、おはようございます。今日は#{I18n.l(moon.fullmoon_time, format: :only_time)}に#{moon.zodiac_sign.name_i18n}で#{moon_type}を#{moon.newmoon_time < Time.current ? '迎えました' : '迎えます'}。半年前に宣言した願いごとが達成されているか、振り返りをしてみませんか？"
    end
  end
end
