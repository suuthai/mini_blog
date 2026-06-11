require 'rails_helper'

RSpec.describe User, type: :model do
  it "constrains of attributes" do
    expect(build(:user, name: "AbcDef").save).to be true
    expect(build(:user, name: "123456").save).to be false
    expect(build(:user, name: "abc def").save).to be false
    expect(build(:user, name: "a" * 21).save).to be false
    expect(build(:user, profile_text: "a" * 201).save).to be false
  end
end
