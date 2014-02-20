# cuba
require "cuba"
require "cuba/render"

# rack
require "rack/protection"
require 'rack-livereload'

# midleware
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
Cuba.use Rack::Protection
Cuba.use Rack::LiveReload

# settings
Cuba.plugin Cuba::Render

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
