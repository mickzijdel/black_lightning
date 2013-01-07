##
# Controller for the about pages.
#
# No actions are defined here. It serves up the files in app/views/about/* using the app/views/layouts/about.html.erb layout.
##
class AboutController < ApplicationController
  before_filter :get_subpages

  ##
  # Returns a list of all the pages in the about folder.
  ##
  def get_subpages
    action = params[:action]

    action_sections = action.split("/")

    @root_page = action_sections[0]

    @subpages_dir = "#{Rails.root}/app/views/about/#{@root_page}/"

    @subpages = []

    exclude = ['index.html.erb']
    @alias = {
      'eutc' => 'EUTC'
    }

    if not File.directory?(@subpages_dir) then
      @subpages_dir = "#{Rails.root}/app/views/about/"
      @root_page = nil
    end

    Dir.foreach(@subpages_dir) do |file|
      if not File.directory?(File.join(@subpages_dir, file)) and not exclude.include? file then
        @subpages << file.gsub(/\.html\.erb/, "")
      end
    end
  end
end
