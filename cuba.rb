#!/usr/bin/env ruby

ENV['RACK_ENV'] = 'development'

require 'rubygems'
require 'bundler/setup'
require 'commander/import'
require './app'

program :version, '0.0.1'
program :description, 'stuff to help with your cuba app'

command :s do |c|
  c.syntax = 'cuba s [options]'
  c.summary = 'will start the server with shotgun'
  # c.description = ''
  # c.example 'description', 'command example'
  # c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    system('shotgun --server=thin -p 9292 config.ru')
  end
end

command :compile do |c|
  c.syntax = 'cuba compile'
  c.summary = 'compiles assets into public folder'
  c.action do |args, options|
    Cuba.all_assets.each do |type, files|
      case type
      when :css
        files.each do |file|
          file.scan(/(.*)\.(\w*)/).each do |f, ext|
            ap({
              f: f,
              ext: ext
            })
          end
        end
      end
    end
  end
end

