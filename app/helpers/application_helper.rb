module ApplicationHelper
  def checkbox(label, field)
    content_tag(:span) { label } +
    image_tag("icons/check_box.gif", :class => 'check_box')
  end
end
