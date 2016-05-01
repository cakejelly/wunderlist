require "spec_helper"

describe Wunderlist::User do
  let(:client) { instance_double("Wunderlist::Client") }

  it "should inherit from Resource" do
    expect(described_class).to be < Wunderlist::Resource
  end

  describe ".me" do
    let(:response) { { name: "Frodo Baggins" } }

    before do
      allow(client).to receive(:get).and_return(response)
    end

    it "should return the authenticated user" do
      described_class.me(client)
      expect(client).to have_received(:get).with("user")
    end

    it "should return new instance of User" do
      expect(described_class.me(client)).to be_instance_of(described_class)
    end
  end
end
