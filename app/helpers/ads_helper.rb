module AdsHelper
  def convert_links(html_string)
    html_string.gsub( %r{(http|https)://[^\s<]+} ) do |url|
      "<a href='#{url}'>#{url}</a>"
    end
  end
end
