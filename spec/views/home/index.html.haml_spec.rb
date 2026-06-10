require 'rails_helper'

RSpec.describe "home/index.html.haml", type: :view do
  it "loading posts at first" do
    render
    assert_select ".loading-posts"
  end
end
