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

    if record.is_form?
      model_name = record.class.model_name.to_s.gsub(/Form$/, '').underscore
    else
      model_name = record.class.model_name.singular
    end

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

    def required?(obj, attr)
      target = (obj.class == Class) ? obj : obj.class
      target.validators_on(attr).map(&:class).include?(
        ActiveRecord::Validations::PresenceValidator
      )
    end

    def errors? obj, attr
      obj.errors.messages[attr.to_sym]
    end

    def wrapper field_name, nested_name, input, options
      mab do
        div class: "form-group #{errors?(record, field_name) ? 'has-error has-feedback' : ''}" do
          label for: id_for(nested_name), class: 'control-label col-sm-2' do
            if required? record, field_name
              abbr title: 'required' do
                text '*'
              end
            end
            text field_name.humanize
          end
          div class: 'col-sm-10' do
            text! input.render
          end
        end
      end
    end

    def submit
      content_for :fields do
        mab do
          input type: 'submit', value: 'Login'
        end
      end

      nil
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

        data = OpenStruct.new({
          name: nested_name,
          record: record,
          value: record.send(field_name),
          options: options,
          errors: record.errors.messages[field_name]
        })

        input = input_class.new data

        wrapper field_name.to_s, nested_name, input, options
      end

      nil
    end

    def fields_for field_name, options = {}, &block
      content_for :fields do
        names = [].concat models
        names << "#{field_name}_attributes"

        associated_record = record.send(field_name)

        fields = Fields.new names, associated_record, block
        fields.render
      end

      nil
    end
  end

  class Input < Struct.new(:data)
    def id
      data.name.gsub(/[^a-z0-9]/, '_').gsub(/__/, '_').gsub(/_$/, '')
    end

    def errors?
      data.errors
    end

    def render
      input
    end
  end
end
