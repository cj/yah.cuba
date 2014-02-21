require 'mimemagic'
require 'rugged'

module Assets
  attr_accessor :git, :assets_cache_string

  def git
    @git ||= Rugged::Repository.new Dir.pwd
  end

  def assets_cache_string
    @cache_string ||= git.head.target
  end

  def asset_path file
    "/assets/#{assets_cache_string}/#{file}"
  end

  def css_assets
    Cuba.settings[:assets][:css]
  end

  module ClassMethods
    def css_assets files
      settings[:assets] ||= {}
      settings[:assets][:css] ||= []

      files.each do |path|
        settings[:assets][:css] << path
      end
    end
  end

  class Routes < Cuba
    define do
      on get, "(.*)\.(js|css|eot|svg|ttf|woff|png|gif|jpg|jpeg)$" do |file, ext|
        res.headers["Content-Type"] = "#{MimeMagic.by_extension(ext).to_s}; charset=utf-8"

        file = file.gsub(/^.*?\//, '')

        if not ext[/(js|css|eot|svg|ttf|woff|png|gif|jpg|jpeg)/]
          res.write render("assets/#{file}.#{ext}")
        else
          if file[/bower/]
            res.write File.read "assets/#{file}.#{ext}"
          else
            case ext
            when 'css'
              res.write File.read "assets/stylesheets/#{file}.#{ext}"
            when 'js'
              res.write File.read "assets/javascripts/#{file}.#{ext}"
            else
              res.write File.read "assets/#{file}.#{ext}"
            end
          end
        end
      end
    end
  end
end
