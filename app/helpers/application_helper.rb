module ApplicationHelper

  def flash_class(level)
    case level
    when 'notice' then "notification is-info"
    when 'success' then "notification is-success"
    when 'error' then "notification is-danger"
    when 'alert' then "notification is-primary"
    end
  end

  def format_date(date)
    return unless date

    date.in_time_zone.strftime('%F')
  end

  def signed_out_or_intro?
    (current_page?(root_path) && signed_out?) || current_page?(intro_path)
  end

end
