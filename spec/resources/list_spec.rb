require "spec_helper"

describe Wunderlist::List do
  it "should inherit from Resource" do
    expect(described_class).to be < Wunderlist::Resource
  end
end
