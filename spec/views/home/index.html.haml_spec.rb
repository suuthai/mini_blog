require 'rails_helper'

RSpec.describe "home/index.html.haml", type: :view do
  it "Title exists" do
    render
    expect(rendered).to include("Home#index")
  end
end
