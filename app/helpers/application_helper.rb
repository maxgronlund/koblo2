module ApplicationHelper
  def checkbox(label, field)
    content_tag(:span) { label } +
    image_tag("icons/check_box.gif", :class => 'check_box')
  end

  def render_activity(activity)
    if activity..instance_of?(SongUploadedActivity)
      content_tag(:li) do
        "#{activity.user.name} added a new song called #{activity.song.title}"
      end
    else
      "Unknown activity type #{activity.id}"
    end
  end
end
