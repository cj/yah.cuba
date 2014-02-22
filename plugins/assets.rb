require 'mimemagic'
require 'base64'

module Assets
  attr_accessor :git, :assets_cache_string

  def self.setup app
    if ENV['RACK_ENV'] == 'production'
      app.use Rack::Static,
        urls: %w[/stylesheets /javascripts /images],
        root: File.expand_path("./public", __dir__)
    end
  end

  def assets_cache_string
    if ENV['RACK_ENV'] == 'production'
      @cache_string ||= File.read "#{Dir.pwd}/sha"
    else
      @cache_string ||= git.head.target
    end
  end

  def asset_path file
    "/assets/#{file}"
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

    def all_assets
      settings[:assets]
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
