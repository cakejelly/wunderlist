require "spec_helper"

describe Wunderlist::Comment do
  it "should inherit from Resource" do
    expect(described_class).to be < Wunderlist::Resource
  end

  describe ".url" do
    it "should be 'task_comments'" do
      expect(described_class.url).to eq("task_comments")
    end
  end
end
