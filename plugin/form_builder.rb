require 'mab/kernel_method'
require "cuba/sugar/content_for"

module FormBuilder
  def self.setup app
    app.plugin Cuba::Sugar::ContentFor
  end

  def form_for record, options = {}, &block
    raise ArgumentError, "Missing block" unless block_given?

    mab do
      div id: 'container' do
        html block.call(Fields.new)
      end
    end
  end

  private

  class Fields < Struct.new(:record)
    def input field_name, options = {}
      mab do
        html do
          p field_name
        end
      end
    end
  end
end
