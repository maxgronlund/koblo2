class PaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
  def to_html
    html = pagination.map do |item|
      RAILS_DEFAULT_LOGGER.error "XXX#{item.inspect}"
      item_html = item.is_a?(Fixnum) ? page_number(item) : send(item)
      if item.is_a?(Fixnum)
        tag(:li, item_html)
      elsif item == :gap
        tag(:li, '...')
      else
        tag(:li, item_html, :class => 'btn')
      end
    end.join(@options[:separator])

    @options[:container] ? html_container(html) : html
  end

  def html_container(html)
    tag(:ul, html, container_attributes)
  end

  def previous_or_next_page(page, text, classname)
    if page
      link(text, page, :class => classname)
    else
      link(text, page, :class => classname + ' disabled')
    end
  end

end

