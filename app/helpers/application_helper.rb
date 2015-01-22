module ApplicationHelper

  def fix_url(url)
    if url.starts_with?('http://')
      url
    else
      'http://' + url
    end
  end

  def format_time(timestamp, timezone=Time.zone.name)
    # Example Format:  Tuesday, January 10, 2014 at 8:42 pm
    format_str = '%A, %B %-d, %Y at %-l:%M %P'
    timestamp.in_time_zone(timezone).strftime(format_str)
  end

end
