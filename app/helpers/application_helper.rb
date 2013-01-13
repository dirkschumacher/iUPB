module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
  end
  
  def fb_like_button
    iframe = <<-HTML
    <iframe src="//www.facebook.com/plugins/like.php?href=#{CGI.escape request.protocol+request.host_with_port+request.fullpath}&amp;send=false&amp;layout=button_count&amp;width=200&amp;show_faces=false&amp;font=arial&amp;colorscheme=light&amp;action=like&amp;height=21&amp;appId=#{Facebook::APP_ID}" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:200px; height:21px;" allowTransparency="true"></iframe>
    HTML
    iframe.html_safe
  end
end
