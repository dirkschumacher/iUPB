class SitemapController < ApplicationController
  layout nil
  before_filter :set_cache_header
  def index
    headers['Content-Type'] = 'application/xml'
    #last_course = Course.last
    #if stale?(:etag => last_course, :last_modified => last_course.updated_at.utc)
      respond_to do |format|
        format.xml { @courses = Course.all } 
      end
    #end
  end
  def courses
    @courses = Course.all
  end
end
