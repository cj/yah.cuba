require_relative "helper"

describe Routes::Home do
  it "#default" do
    visit '/'

    expect(page).to have_content 'moo'
  end
end
