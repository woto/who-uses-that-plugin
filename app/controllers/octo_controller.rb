class OctoController < ApplicationController

  require 'nokogiri'
  require 'open-uri'
  include Octopi

  def index
    @repos = Repository.find_all("blog")
    # curl http://github.com/api/v2/yaml/repos/search/blog?start_page=6 
    @repos.each do |repo|
      if @repos.first != repo
        break
      end
      
      logger.debug(repo)

      doc = Nokogiri::HTML(open("http://github.com/#{repo.username}/#{repo.name}/tree/master/vendor/plugins/"))
      application = Application.new(:name => repo.name)
      #application.owner = repo.owner
      once = true
      doc.xpath('/html/body/div[@id="main"]/div[@class="site"]/div[@id="browser"]/table/tr/td[2]').each do |plugin|
        if once && plugin.text != ' .. '
          break
        else
          once = false
        end
        
        application.plugins << Plugin.new(:name => plugin.text)
      end

      unless application.plugins.empty? 
        application.save
      end
    end

  end
end
