module ApplicationHelper
  def page_title(page_title = '')
    base_title = t 'defaults.site_title'

    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end
end
