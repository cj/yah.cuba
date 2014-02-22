## require
# cuba
require "cuba"
require "cuba/render"

# plugins
Dir["./plugins/**/*.rb"].each  { |rb| require rb  }

# rack
require "rack/protection"

## development only
if ENV['RACK_ENV'] == 'development'
  require 'rack-livereload'
  Cuba.use Rack::LiveReload
end
if ENV['RACK_ENV'] == 'development' or ENV['RACK_ENV'] == 'test'
  require 'pry'
  require 'awesome_print'
end

## plugins
Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = 'haml'
Cuba.plugin Environment
Cuba.plugin Assets

## midleware
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
Cuba.use Rack::Protection

# grab all the routes
Dir["./routes/**/*.rb"].each  { |rb| require rb  }

# set assets

Cuba.image_assets [
  'logo.gif'
]

Cuba.css_assets [
  'bower/bootstrap/dist/css/bootstrap.min.css',
  'bower/font-awesome/css/font-awesome.min.css',
  'style.css'
]

if ENV['RACK_ENV'] == 'production'
end


Cuba.define do
  on get, 'assets' do
    run Assets::Routes
  end

  on root do
    res.write view("home/index")
  end
end
