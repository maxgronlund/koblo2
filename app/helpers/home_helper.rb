module HomeHelper
  def tab_link(name)
    scope = name.parameterize('_')
    css_class = 'cufon'
    if current_page?(:controller => 'songs', :action => 'index', :scope => scope)
      css_class += ' selected'
    else
      css_class += ' unselected'
    end
    content_tag(:li, :class => css_class) {
      link_to(name, :controller => 'songs', :action => 'index', :scope => scope)
    }
  end
end
