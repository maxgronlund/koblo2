module UsersHelper
  def user_tab(name, url)
    css_class = 'cufon'
    css_class += ' selected' if current_page?(url)
    content_tag(:li, :class => css_class) {
      link_to(name, url)
    }
  end
end
