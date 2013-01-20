module AdsHelper
  def convert_links(html_string)
    html_string.gsub( %r{(http|https)://[^\s<]+} ) do |url|
      "<a href='#{url}'>#{url}</a>"
    end
  end
  
  # https://github.com/jney/jquery.pageless
  def pageless(total_pages, url=nil, container=nil)
    content_for :javascript do
      js = <<-JS
      <script>
        $('#results').pageless({
          "totalPages":#{total_pages},
          "url":"#{url}",
          "loaderMsg":"#{t("loading")}",
          "loaderImage":"#{image_path("load.gif")}",
          "distance": 150,
          "complete":function(){
            $("#posts").append(window.iUPB.Ads.generateGrid($(".single_post"), {"doNotDelete": true}));
            $(".post_time_to_timeago").each(function() {
          		$this = $(this);
        	    $this.text($.timeago($this.text()));
    	    		$this.removeClass("post_time_to_timeago");
          	});
          },
          "container":"#{container}"
        });
      </script>
      JS
      js.html_safe
    end
  end
  
  
end
