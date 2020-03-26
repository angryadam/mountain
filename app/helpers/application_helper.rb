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

  def navbar_logo_path
    signed_in? ? root_path : intro_path
  end

end
