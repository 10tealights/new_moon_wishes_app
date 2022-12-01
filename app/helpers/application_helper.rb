module ApplicationHelper
  require 'net/http'
  require 'uri'
  require 'json'

  def page_title(page_title = '')
    base_title = t 'defaults.site_title'

    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # 各ページの説明文 120文字前後
  def full_description(page_description = '')
    base_description = t 'defaults.site_description_long' 
    if page_description.empty?
      base_description
    else
      page_description
    end
  end
  
  # 各ページの説明文 50文字前後
  def og_description(page_description = '')
    base_description = t 'defaults.site_description_short' 
    if page_description.empty?
      base_description
    else
      page_description
    end
  end
  
  # 各ページのイメージ画像
  def og_image(page_image = '')
    base_image = image_url('clarus_ogp.png')
    if page_image.empty?
      base_image
    else
      page_image
    end
  end

  def next_newmoon
    Moon.latest
  end

  def get_moon_age
    today = Time.current
    age_info = Net::HTTP.get(URI.parse("https://labs.bitmeister.jp/ohakon/json/?mode=moon_age&year=#{today.year}&month=#{today.month}&day=#{today.day}")) 
    parsed_age_info = JSON.parse(age_info)
    parsed_age_info['moon_age']
  end

  def moon_phase_image
    moon_age = get_moon_age
    newmoon = Moon.find_by(newmoon_time: Time.current.all_day)
    fullmoon = Moon.find_by(fullmoon_time: Time.current.all_day)
    moon_age_integer = moon_age.floor
    difference = moon_age - moon_age_integer

    case
    when newmoon.present?
      return 0
    when fullmoon.present?
      return 15
    when moon_age_integer == 29
      return 0
    when difference >= 0.5
      if moon_age_integer < 28
        return moon_age_integer + 1
      else
        return 0 
      end
    when difference < 0.5
      return moon_age_integer
    end
  end

  def hidden_if(action)
    params[:action] == action ? 'hidden' : 'flex'
  end

  def fullmoon_emoji_if(declaration)
    declaration.fulfilled? ? "&#127765;".html_safe : "&#127761;".html_safe
  end

  def highlight(come_true)
    case come_true
    when 'fulfilled'
      'bg-gradient-to-b from-yellow-200 via-yellow-100 to-yellow-50'
    when 'removed'
      'opacity-60'
    end
  end
end
