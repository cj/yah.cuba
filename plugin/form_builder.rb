require 'mab/kernel_method'
require "cuba/sugar/content_for"

module FormBuilder
  include Cuba::Sugar::ContentFor

  def self.setup app
    app.plugin Cuba::Sugar::ContentFor
  end

  def form_for record, options = {}, &block
    raise ArgumentError, "Missing block" unless block_given?

    block.call self

    mab do
      html do
        div id: 'container' do
          yield_for(:fields).each do |field|
            text! field
          end
        end
      end
    end
  end

  def input field_name, options = {}
    content_for :fields do
      mab do
        p field_name
      end
    end
    ''
  end

  private

  class Fields < Struct.new(:record)
  end
end
