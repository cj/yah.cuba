module FormBuilder
  class StringInput < Input
    def input
      input_options = {
        name: name,
        type: :text,
        id: id,
        class: 'form-control',
        value: value
      }.merge! options

      mab do
        input input_options
      end
    end
  end
end
