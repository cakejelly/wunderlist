require "spec_helper"

describe Wunderlist::Resource do
  describe ".class_name" do
    it "should return the class name as a String" do
      expect(described_class.class_name).to eq("Resource")
    end
  end

  describe ".url" do
    it "should return url representation of the class name" do
      expect(described_class.url).to eq("resources")
    end
  end

  describe "API operations" do
    let(:client) { instance_double("Wunderlist::Client") }

    describe ".all" do
      let(:response) { [{ attribute: "value" }, { attribute: "value" }] }

      before do
        allow(client).to receive(:get).and_return(response)
      end

      it "should make a GET request to retrieve resource collection" do
        expect(client).to receive(:get).with("resources", {})
        described_class.all(client)
      end

      it "should return an array of resource objects" do
        collection = described_class.all(client)
        collection.each do |resource|
          expect(resource).to be_instance_of(described_class)
        end
      end
    end

    describe ".find" do
      let(:response) { { attribute: "value" } }
      let(:id) { "3" }

      before do
        allow(client).to receive(:get).and_return(response)
      end

      it "should make a GET request to retrieve resource" do
        expect(client).to receive(:get).with("resources/#{id}")
        described_class.find(client, id)
      end

      it "should return an instance of Resource" do
        resource = described_class.find(client, id)
        expect(resource).to be_instance_of(described_class)
      end
    end

    describe ".create" do
      let(:response) { { attribute: "value" } }
      let(:params) { { name: "Homer Simpson" } }

      before do
        allow(client).to receive(:post).and_return(response)
      end

      it "should make a POST request to create new resource" do
        expect(client).to receive(:post).with("resources", params)
        described_class.create(client, params)
      end

      it "should return a new instance of Resource" do
        resource = described_class.create(client, params)
        expect(resource).to be_instance_of(described_class)
      end
    end

    describe ".update" do
      let(:response) { { attribute: "value" } }
      let(:params) { { name: "Homer Simpson" } }
      let(:id) { "3" }

      before do
        allow(client).to receive(:patch).and_return(response)
      end

      it "should make a PATCH request to update the resource" do
        described_class.update(client, id, params)
        expect(client).to have_received(:patch).with("resources/#{id}", params)
      end

      it "should return a new instance of Resource" do
        resource = described_class.update(client, id, params)
        expect(resource).to be_instance_of(described_class)
      end
    end

    describe ".destroy" do
      let(:id) { "3" }

      before do
        allow(client).to receive(:delete).and_return(true)
      end

      it "should make a DELETE request to delete the resource" do
        described_class.destroy(client, id)
        expect(client).to have_received(:delete).with("resources/#{id}?")
      end

      it "should send payload as query params" do
        payload = { revision: "1" }
        described_class.destroy(client, id, payload)
        expect(client).to have_received(:delete).with("resources/#{id}?revision=1")
      end

      it "should return true if successful" do
        expect(described_class.destroy(client, id)).to be true
      end
    end
  end

  describe "#new" do
    it "should accept and assign attributes" do
      attributes = { attribute: "value" }
      resource = described_class.new(attributes, nil)
      expect(resource.attributes).to eq(attributes)
    end

    it "should accept and assign an instance of client" do
      client = instance_double("Layer::Client")
      resource = described_class.new(nil, client)
      expect(resource.client).to eq(client)
    end
  end
end
