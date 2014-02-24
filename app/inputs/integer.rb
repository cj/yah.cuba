module FormBuilder
  class IntegerInput < Input
    def input
      input_options = {
        name: data.name,
        type: :text,
        id: id,
        class: 'form-control',
        value: data.value
      }.merge! data.options

      mab do
        input input_options

        if errors?
          span class: 'help-block has-error' do
            text data.errors.join ' '
          end
          span class: 'fa fa-times form-control-feedback'
        end
      end
    end
  end
end
