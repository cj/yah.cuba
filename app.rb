## require
# cuba
require "cuba"
require "cuba/render"

require "./plugin/enviroment"
Cuba.plugin Environment

# database
require 'active_record'

# rack
require "rack/protection"

## development only
if Cuba.development?
  require 'rack-livereload'
  Cuba.use Rack::LiveReload
end

if Cuba.development? or Cuba.test?
  require 'pry'
  require 'awesome_print'
end

## midleware
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
Cuba.use Rack::Protection
Cuba.use Rack::Reloader

## add renderer and assets
Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = 'haml'
Cuba.settings[:render][:views] = File.expand_path("app/views", Dir.pwd)
require './plugin/assets'
Cuba.plugin Assets

## configs
Dir["./config/**/*.rb"].each  { |rb| require rb  }

## routes
Dir["./app/routes/**/*.rb"].each  { |rb| require rb  }

Cuba.define do
  on get, 'assets' do
    run Assets::Routes
  end

  on root do
    res.write view("home/index")
  end
end
