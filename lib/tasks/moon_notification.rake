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
      p "#{Time.current}: 該当なし"
    end
  end

  def send_line_notifications(target_users, moon, moon_type)
    target_users.each do |user|
      message = {
        type: 'flex',
        altText: "#{moon.zodiac_sign.name_i18n}#{moon_type}のお知らせ",
        contents: flex_message(user, moon, moon_type)
      }
      line_uid = user.authentications.find_by(provider: 'line')&.uid
      LineNotificationJob.perform_later(line_uid, message) if line_uid.present?
    end
  end

  def flex_message(user, moon, moon_type)
    {
      "type": "bubble",
      "hero": {
        "type": "image",
        "url": "#{moon_type.include?('新月') ? 'https://res.cloudinary.com/dhbscendw/image/upload/v1669192782/line_notice_newmoon_xeecky.jpg' : 'https://res.cloudinary.com/dhbscendw/image/upload/v1669193825/line_notice_fullmoon_kwoutr.jpg'}",
        "size": "full",
        "aspectRatio": "16:9",
        "aspectMode": "cover",
        "action": {
          "type": "uri",
          "uri": "#{I18n.t('defaults.site_url')}"
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
                    "text": greeting_message(user, moon, moon_type),
                    "wrap": true,
                    "color": "#666666",
                    "size": "sm",
                    "flex": 5,
                    "align": "start"
                  }
                ]
              }
            ]
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
                    "text": "#{moon_type.include?('新月') ? '【おすすめのテーマ】' : '【願いごと】'}",
                    "wrap": true,
                    "color": "#aaaaaa",
                    "size": "sm",
                    "flex": 1,
                    "align": "center"
                  },
                ]
              }
            ]
          },
          {
            "type": "box",
            "layout": "baseline",
            "margin": "lg",
            "spacing": "sm",
            "contents": [
              {
                "type": "text",
                "text": declaration_message(user, moon, moon_type),
                "wrap": true,
                "size": "sm",
                "color": "#666666",
                "flex": 5
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
              "uri": "#{moon_type.include?('新月') ? "#{I18n.t('defaults.site_url')}/wishes/new" : "#{I18n.t('defaults.site_url')}/wishes"}"
            }
          }
        ],
        "flex": 0
      }
    }
  end

  def greeting_message(user, moon, moon_type)
    if moon_type == '新月'
      content = "#{user.name}さん、おはようございます。今日は#{I18n.l(moon.newmoon_time, format: :only_time)}に#{moon.zodiac_sign.name_i18n}で#{moon_type}を#{moon.newmoon_time < Time.current ? '迎えました' : '迎えます'}。新月から48時間以内に願いごとを宣言してみませんか？"
    elsif moon_type == '満月'
      content = "#{user.name}さん、おはようございます。今日は#{I18n.l(moon.fullmoon_time, format: :only_time)}に#{moon.zodiac_sign.name_i18n}で#{moon_type}を#{moon.newmoon_time < Time.current ? '迎えました' : '迎えます'}。半年前に宣言した願いごとが達成されているか、振り返りをしてみませんか？"
    end
  end

  def declaration_message(user, moon, moon_type) 
    if moon_type == '新月'
      content = "#{moon.zodiac_sign.traits.map(&:keyword).join('・')}"
    elsif moon_type == '満月'
      content = user.wishes.find_by(moon_id: moon.id)&.declarations.map.with_index(1){ |declaration, i| "#{i}.#{declaration.message}" }.join("\n")
    end
  end
end
