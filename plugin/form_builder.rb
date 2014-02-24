require 'mab/kernel_method'
require "cuba/sugar/content_for"
require "cuba/sugar/csrf"

module FormBuilder
  attr_accessor :record

  def self.setup app
    app.plugin Cuba::Sugar::ContentFor
    Cuba.use Rack::Csrf
    Cuba.plugin Cuba::Sugar::Csrf
    Dir["./app/inputs/**/*.rb"].each  { |rb| require rb  }
  end

  def form_for record, options = {}, &block
    raise ArgumentError, "Missing block" unless block_given?

    model_name = record.class.model_name.singular

    fields = Fields.new [model_name],record, block

    form_options = {
      class: 'form-horizontal',
      role: 'form',
      method: 'post',
      action: options.delete(:url) || "/" + record.class.model_name.plural
    }.merge! options

    mab do
      form form_options do
        input type: 'hidden', name: '_method', value: (record.id ? 'post' : 'patch')
        text! csrf_tag
        text! fields.render
      end
    end
  end

  class Fields < Struct.new(:models, :record, :block)
    include Cuba::Sugar::ContentFor

    def render
      block.call self

      mab do
        yield_for(:fields).each do |field|
          text! field
        end
      end
    end

    def id_for field_name
      field_name.gsub(/[^a-z0-9]/, '_').gsub(/__/, '_').gsub(/_$/, '')
    end

    def wrapper field_name, nested_name, input, options
      mab do
        div class: 'form-group' do
          label for: id_for(nested_name), class: 'col-sm-2' do
            field_name.humanize
          end
          div class: 'col-sm-10' do
            text! input.render
          end
        end
      end
    end

    def input field_name, options = {}
      content_for :fields do
        names = [].concat models
        names << field_name

        # create field names that map to the correct models
        nested_name = names.each_with_index.map do |field, i|
          i != 0 ? "[#{field}]" : field
        end.join

        record_class = record.class.model_name.name.constantize
        record_type = record_class.columns_hash[field_name.to_s].type.to_s.classify
        input_class = "FormBuilder::#{record_type}Input".constantize
        input = input_class.new nested_name, record, record.send(field_name), options
        wrapper field_name.to_s, nested_name, input, options
      end

      nil
    end

    def fields_for field_name, options = {}, &block
      content_for :fields do
        names = [].concat models
        names << field_name

        fields = Fields.new names, record.send("build_#{field_name}"), block
        fields.render
      end

      nil
    end
  end

  class Input < Struct.new(:name, :record, :value, :options)
    def id
      name.gsub(/[^a-z0-9]/, '_').gsub(/__/, '_').gsub(/_$/, '')
    end

    def render
      input
    end
  end
end
