require_relative 'models'
require 'roda'
require 'sequel'
require 'date'



class TwatbotWeb < Roda
  # OPTIONS
  #opts[:add_script_name] = true

  # CONSTANTS
  SESSION_TIMEOUT_SECONDS = 600
  SESSION_SECRET = "\x3c\x16\xderpderp..."
  IMAGE_PATH = "images/urldb/"
  URL_SEARCH_PAGE_SIZE = 20

  # Plugins
  plugin :public
  plugin :sessions, secret: SESSION_SECRET, key: 'TwatbotWeb.session', max_idle_seconds: SESSION_TIMEOUT_SECONDS
  plugin :render, :escape=>true
  plugin :assets
  plugin :flash
  plugin :path

  path :approot, '/'
  path :urls, '/urls'


  route do |r|
    r.public
    @session = r.session
    @approot = approot_path
    @params = r.params
    @query_string = r.query_string

    # GET /
    r.root do
      r.redirect urls_path
    end

    # GET /urls
    r.get "urls" do

      @result_count = -1

      # Build SQL query
      @urls = TitleBotUrl.dataset

      if @query_string.to_s.length > 0  

        #sanitize search parameters:

        if @params['startDate'].to_s.strip =~ /^\d{4}-\d{2}-\d{2}$/
          @params['startDate'] = @params['startDate'].to_s.strip
          a = Date.parse @params['startDate'] rescue nil
          @params['startDate'] = nil if a.nil?
        else
          @params['startDate'] = nil
        end

        if @params['endDate'].to_s.strip =~ /^\d{4}-\d{2}-\d{2}$/
          @params['endDate'] = @params['endDate'].to_s.strip
          a = Date.parse @params['endDate'] rescue nil
          @params['endDate'] = nil if a.nil?
        else
          @params['endDate'] = nil
        end

        @params['nick'] = @params['nick'].to_s.strip.gsub(/[^ -~]/,'')
        @params['nick'] = nil if @params['nick'].to_s.length <= 0

        @params['url'] = @params['url'].to_s.strip.gsub(/[^ -~]/,'')
        @params['url'] = nil if @params['url'].to_s.length <= 0

        @params['title'] = @params['title'].to_s.strip.gsub(/[^ -~]/,'')
        @params['title'] = nil if @params['title'].to_s.length <= 0


        if @params['startDate'].to_s.length > 0
          x = @params['startDate'].to_s
          @urls = @urls.where{self.>=(:Date, DateTime.strptime(x,"%Y-%m-%d"))}
        end

        if @params['endDate'].to_s.length > 0
          x = @params['endDate'].to_s
          @urls = @urls.where{self.<(:Date, DateTime.strptime(x,"%Y-%m-%d") + 1)}
        end

        if @params['nick'].to_s.length > 0
          @urls = @urls.where(Sequel.ilike(:Nick, "%#{@urls.escape_like(@params['nick'].to_s)}%"))
        end

        if @params['url'].to_s.length > 0
          @urls = @urls.where(Sequel.ilike(:URL, "%#{@urls.escape_like(@params['url'].to_s)}%"))
        end

        if @params['title'].to_s.length > 0
          @urls = @urls.where(Sequel.ilike(:Title, "%#{@urls.escape_like(@params['title'].to_s)}%"))
        end
      end

      if @params["page"].to_s =~ /^\d+$/
        @mypage = @params["page"].to_i
      else
        @mypage = 1
      end

      @urls = @urls.order(Sequel.desc(:Date))
      @urls_temp = @urls.paginate(@mypage, URL_SEARCH_PAGE_SIZE)
      @maxpage = @urls_temp.page_count
      @result_count = @urls_temp.pagination_record_count

      if @mypage > @maxpage
        @mypage = 1
        @urls_temp = @urls.paginate(@mypage, URL_SEARCH_PAGE_SIZE)
      end

      @urls = @urls_temp
      @image_path = IMAGE_PATH
      #@search_errors = @urls.sql + '<br/>' + @urls.all.inspect.to_s


      view "urls"
    end


  end
end
