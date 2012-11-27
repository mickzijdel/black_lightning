class StaticController < ApplicationController

  def home
    @news = News.all(:conditions => ["publish_date <= ? AND show_public = ?", Date.current, true], :order => "publish_date DESC")
    @shows = Show.current(:limit => 5)
  end

  def about
  end

  def access_denied
    respond_to do |format|
      format.html { render :status => 403 }
    end
  end

  def render_404
    respond_to do |type|
      type.html { render :template => "static/404", :layout => 'application' }#, :status => 404 }
      type.all  { render :nothing => true, :status => 404 }
    end
  end
end
