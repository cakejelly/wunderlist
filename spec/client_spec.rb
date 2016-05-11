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
          url = "#{described_class::BASE_URL}/url"
          expect(RestClient::Request).to receive(:execute).
                                          with(hash_including({url: url}))
          subject.make_request(method, "url")
        end

        it "should send correct headers" do
          header = { "Some-Header" =>  "value" }
          headers = subject.default_headers.merge(header)
          expect(RestClient::Request).to receive(:execute).
                                          with(hash_including({headers: headers}))
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

    %w{get post patch delete}.each do |method|
      describe "##{method}" do
        before do
          allow(subject).to receive(:make_request).and_return({body: "some body"})
        end

        it "should send #{method} to #make_request" do
          expect(subject).to receive(:make_request).with(method.to_sym, {}, {})
          subject.send(method, {})
        end

        it "should send correct payload" do
          params = {one: "two"}
          expect(subject).to receive(:make_request).with(method.to_sym, params, {})
          subject.send(method, params)
        end
      end
    end
  end

  describe "#lists" do
    it "should return instance of ResourceProxy" do
      expect(subject.lists).to be_instance_of(Wunderlist::ResourceProxy)
    end

    it "should proxy methods to List" do
      proxy = subject.lists
      expect(proxy.resource).to eq(Wunderlist::List)
    end
  end

  describe "#users" do
    it "should return instance of ResourceProxy" do
      expect(subject.users).to be_instance_of(Wunderlist::ResourceProxy)
    end

    it "should proxy methods to User" do
      proxy = subject.users
      expect(proxy.resource).to eq(Wunderlist::User)
    end
  end

  describe "#webhooks" do
    it "should return instance of ResourceProxy" do
      expect(subject.webhooks).to be_instance_of(Wunderlist::ResourceProxy)
    end

    it "should proxy methods to Webhook" do
      proxy = subject.webhooks
      expect(proxy.resource).to eq(Wunderlist::Webhook)
    end
  end

  describe "#tasks" do
    it "should return instance of ResourceProxy" do
      expect(subject.tasks).to be_instance_of(Wunderlist::ResourceProxy)
    end

    it "should proxy methods to Task" do
      proxy = subject.tasks
      expect(proxy.resource).to eq(Wunderlist::Task)
    end
  end

  describe "#subtasks" do
    it "should return instance of ResourceProxy" do
      expect(subject.subtasks).to be_instance_of(Wunderlist::ResourceProxy)
    end

    it "should proxy methods to Subtask" do
      proxy = subject.subtasks
      expect(proxy.resource).to eq(Wunderlist::Subtask)
    end
  end
end
