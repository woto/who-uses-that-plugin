class OctoController < ApplicationController

  # todo Что еще проработать:
  # 1. на примере http://github.com/edavis10/redmine/tree/master/vendor/
  # существует еще папка gems (пока не знаю как её используют)
  # 2. на примере http://github.com/edavis10/redmine/tree/master/vendor/plugins/
  # плагин может содержать номер версии
  # 3. на примере http://github.com/pjhyett/github-services/tree/master/vendor/
  # плагины могут лежать не в папке plugins
  # 4. на примере http://github.com/karmi/marley/tree/master/vendor/ 
  # плагины могут лежать как submodule и содержать приписки "sinatra-sinatra - 0ade0be"	 
  # 5. просто кладут *.rb файлы http://github.com/karmi/marley/tree/master/vendor/ 

STR = [
"russian",
"facker",
"factory",
"facker",
"moscow",
"git",
"resource",
"nested",
"view",
"jquery",
"jrails",
"cells_examples",
"api_cache",
"authlogic",
"authlogic_rpx",
"auto_complete",
"awesome_nested_set",
"calendar_date_select",
"cancan",
"feedzirra",
"formtastic",
"formtastic_calendar_date_select",
"friendly_id",
"nokogiri",
"octopi",
"paperclip",
"rails-ckeditor",
"rails-footnotes",
"rpx_now",
"russian",
"sitemap_generator",
"sprockets",
"sprockets-rails",
"table_builder",
"thinking-sphinx",
"validates_captcha",
"validates_timeliness",
"validation_reflection",
"weakling",
"will_paginate",
"www-delicious",
"cms",
"blog",
"tutorial",
"example",
"video",
"attachment",
"shop",
"cart",
"xml",
"rss",
"atom",
"demo",
"screencast",
"ping",
"twitter",
"oauth",
"openid",
"javascript",
"lightbox",
"bookmark",
"tab",
"carousel",
"optimize",
"amazon",
"youtube",
"webmoney",
"merchant",
"active_merchant",
"cart",
"shop",
"in-place",
"inplace",
"wysiwyg",
"editor",
"pagination"]

  require 'nokogiri'
  require 'open-uri'
  include Octopi

  def index
    STR.each do |str|
      1.upto(5).each do |i|
        begin
          s_url = "http://github.com/api/v2/yaml/repos/search/#{str}?start_page=#{i}"
          puts s_url
          yaml = open(s_url)
          xml = YAML.parse(yaml).transform.to_xml
          doc_search = Nokogiri::XML(xml)
          doc_search.xpath("/hash/repositories/repository").each do |repo|
            s_username = repo.xpath('./username').text
            s_application = repo.xpath('./name').text
            i_followers = repo.xpath('./followers').text.to_i
            i_score = repo.xpath('./score').text.to_f
            next if i_followers < 2

            puts "-- #{s_username} #{s_application}"
            
            application = Application.find_or_create_by_name(s_application)
            begin
              s_url = "http://github.com/#{s_username}/#{s_application}/tree/master/vendor/plugins/"
              doc_plugin = Nokogiri::HTML(open(s_url))
              
              # Смотрим vendor/plugin
              once = true
              doc_plugin.xpath('/html/body/div[@id="main"]/div[@class="site"]/div[@id="browser"]/table/tr/td[2]').each do |plugin|
                s_plugin = plugin.text
                s_plugin.gsub!(/[ \/]/, "")
                if once
                  once = false
                  if s_plugin != '..'
                    break
                  elsif s_plugin == '..'
                    next
                  end
                end

                
                puts s_plugin
  
                application.plugins << Plugin.find_or_create_by_name(s_plugin)
              end

            rescue 
              nil
            end

            # Парсим environment.rb на предмет config.gem ...
            begin
              s_url = "http://github.com/#{s_username}/#{s_application}/raw/master/config/environment.rb"
              s_line = open(s_url).read

              a_gems = s_line.scan(/config.gem.*?\(?["'](.*?)['"]\)?/) 
              puts a_gems

              a_gems.each do |a_gem|
                application.plugins << Plugin.find_or_create_by_name(a_gem[0])
              end
            rescue 
              nil 
            end

            unless application.plugins.empty? 
              application.save
            end
          end
        
        # Переходим к следующей странице
        rescue 
          retry 
        end

      end
    end
  end
end
