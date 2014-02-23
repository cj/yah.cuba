require_relative "helper"

scope do
  test "Home" do
    visit '/'

    assert has_content? 'moo'
  end
end
