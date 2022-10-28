module ApplicationHelper
  def page_title(page_title = '')
    base_title = t 'defaults.site_title'

    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def hidden_if(action)
    params[:action] == action ? 'flex' : 'hidden'
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
