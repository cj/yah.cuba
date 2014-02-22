require 'mimemagic'
require 'base64'
if ENV['RACK_ENV'] != 'production'
  require 'rugged'
end

module Assets
  attr_accessor :git, :assets_cache_string

  def self.setup app
    if ENV['RACK_ENV'] == 'production'
      app.use Rack::Static,
        urls: [
          "/public/#{app.assets_cache_string}/stylesheets",
          "/public/#{app.assets_cache_string}/javascripts",
          "/public/#{app.assets_cache_string}/bower",
          "/public/#{app.assets_cache_string}/images",
        ],
        root: './'
      app.use Rack::Deflater
    end
  end

  def assets_cache_string
    if ENV['RACK_ENV'] == 'production'
      @cache_string ||= File.read "#{Dir.pwd}/sha"
    else
      repo = Rugged::Repository.new('./')
      @cache_string ||= repo.head.target
    end
  end

  def asset_path file
    if production?
      if file[/bower/]
        "/public/#{assets_cache_string}/#{file}"
      else
        case file[/(\.[^.]+)$/]
        when '.css'
          ext_path = 'stylesheets'
        when '.js'
          ext_path = 'javascripts'
        else
          ext_path = 'images'
        end
        "/public/#{assets_cache_string}/#{ext_path}/#{file}"
      end
    else
      "/assets/#{file}"
    end
  end

  def image_assets
    Cuba.settings[:assets][:css]
  end

  def css_assets
    Cuba.settings[:assets][:css]
  end

  def accepted_assets
    "(.*)\.(js|css|eot|svg|ttf|woff|png|gif|jpg|jpeg)$"
  end

  module ClassMethods
    def css_assets files
      settings[:assets] ||= {}
      settings[:assets][:css] ||= []

      files.each do |path|
        settings[:assets][:css] << path
      end
    end

    def image_assets files
      settings[:assets] ||= {}
      settings[:assets][:css] ||= []

      files.each do |path|
        settings[:assets][:css] << path
      end
    end

    def all_assets
      settings[:assets]
    end

    def assets_cache_string
      if ENV['RACK_ENV'] == 'production'
        @cache_string ||= File.read "#{Dir.pwd}/sha"
      else
        repo = Rugged::Repository.new('./')
        @cache_string ||= repo.head.target
      end
    end
  end

  class Routes < Cuba
    define do
      on get, development?, accepted_assets do |file, ext|
        res.headers["Content-Type"] = "#{MimeMagic.by_extension(ext).to_s}; charset=utf-8"
        # file = file.gsub(/^.*?\//, '')

        if not ext[/(js|css|eot|svg|ttf|woff|png|gif|jpg|jpeg)/]
          res.write render("assets/#{file}.#{ext}")
        else
          if file[/bower/]
            res.write File.read "#{Dir.pwd}/assets/#{file}.#{ext}"
          else
            case ext
            when 'css'
              res.write File.read "#{Dir.pwd}/assets/stylesheets/#{file}.#{ext}"
            when 'js'
              res.write File.read "#{Dir.pwd}/assets/javascripts/#{file}.#{ext}"
            else
              res.write File.read "#{Dir.pwd}/assets/#{file}.#{ext}"
            end
          end
        end
      end
    end
  end
end
