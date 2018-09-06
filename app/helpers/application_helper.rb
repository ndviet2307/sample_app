module ApplicationHelper
  def full_title page_title = ""
    base_title = t "static_pages.rails_tutorial"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
