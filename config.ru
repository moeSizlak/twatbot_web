require 'roda'
require_relative 'models'
require './twatbot_web.rb'

=begin
class App < Roda
  route do |r|
    # GET / request
    r.root do
      #r.redirect "/hello"
      "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    end

    # /hello branch
    r.on "hello" do
      # Set variable for all routes in /hello branch
      @greeting = 'Hello'

      # GET /hello/world request
      r.get "world" do
        "#{@greeting} world!"
      end

      # /hello request
      r.is do
        # GET /hello request
        r.get do
          "#{@greeting}!"
        end

        # POST /hello request
        r.post do
          puts "Someone said #{@greeting}!"
          r.redirect
        end
      end
    end
  end
end
=end

run TwatbotWeb.freeze.app