module ApplicationHelper
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
