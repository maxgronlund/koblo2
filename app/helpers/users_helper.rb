module UsersHelper
  def tab(name, url)
    css_class = 'cufon'
    content_tag(:li, :class => css_class) {
      link_to(name, url)
    }
  end
end
