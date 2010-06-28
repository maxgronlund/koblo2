module HomeHelper
  def tab_link(name, default = false)
    scope = name.parameterize('_')
    css_class = 'cufon'
    if current_page?(:action => 'index', :scope => scope) || (default && params[:scope].blank?)
      css_class += ' selected'
    else
      css_class += ' unselected'
    end
    content_tag(:li, :class => css_class) {
      link_to(name, :action => 'index', :scope => scope)
    }
  end
end
