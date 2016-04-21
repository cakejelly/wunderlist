require "spec_helper"

describe Wunderlist::Client do
  let(:client_id) { "client_id" }
  let(:access_token) { "client_id" }
  subject { described_class.new(client_id, access_token) }

  describe "#new" do
    it "should accept and assign client ID and access token as arguments" do
      expect(subject.client_id).to eq(client_id)
      expect(subject.access_token).to eq(access_token)
    end
  end

  describe "#make_request" do
    let(:some_response) { { "body" => "text" } }

    before do
      allow(RestClient::Request).to receive(:execute).and_return(some_response.to_json)
    end

    %w{get post put delete}.each do |method|
      describe "with HTTP #{method.upcase}" do
        it "should return true when response has no body" do
          allow(RestClient::Request).to receive(:execute).and_return("")
          response = subject.make_request(method, "/")
          expect(response).to be true
        end

        it "should send correct URL" do
          expect(RestClient::Request).to receive(:execute).
                                          with(hash_including({url: "/"}))
          subject.make_request(method, "/")
        end

        it "should send correct headers" do
          header = { "Some-Header" =>  "value" }
          expect(RestClient::Request).to receive(:execute).
                                          with(hash_including({headers: header}))
          subject.make_request(method, "/", {}, header)
        end

        it "should send payload as JSON" do
          payload = { param: "one" }
          expect(RestClient::Request).to receive(:execute).
                                          with(hash_including({payload: payload.to_json}))
          subject.make_request(method, "/", payload)
        end

        it "should parse JSON response" do
          response = subject.make_request(method, "/")
          expect(response).to eq(some_response)
        end
      end
    end
  end
end
