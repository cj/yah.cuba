# cuba
require "cuba"
require "cuba/render"

# plugins
require './plugins/enviroment'

# rack
require "rack/protection"

if ENV['RACK_ENV'] == 'development'
  require 'rack-livereload'
  Cuba.use Rack::LiveReload
end

# midleware
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
Cuba.use Rack::Protection

Cuba.plugin Cuba::Render
Cuba.plugin Environment

# midleware
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
Cuba.use Rack::Protection

Cuba.define do
  on get do
    on "hello" do
      res.write render("views/hello.haml")
    end

    on "styles", extension("js") do |file|
      res.headers["Content-Type"] = "text/javascript; charset=utf-8"

      res.write render("styles/#{file}.coffee")
    end

    on root do
      res.redirect "/hello"
    end
  end
end
