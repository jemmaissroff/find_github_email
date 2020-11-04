# frozen_string_literal: true

require "find_github_email/errors"

RSpec.describe FindGithubEmail::GithubAccessToken do
  let(:access_token) { "access token" }

  after(:each) do
    if File.exist?(described_class::ACCESS_TOKEN_FILE_PATH)
      File.delete(described_class::ACCESS_TOKEN_FILE_PATH)
    end
  end

  describe ".github_access_token" do
    subject { described_class.github_access_token }

    context "when an access token exists" do
      before(:each) do
        File.write(described_class::ACCESS_TOKEN_FILE_PATH, access_token)
      end

      it "returns the access token" do
        expect(subject).to eq(access_token)
      end
    end

    context "when an access token does not exist" do
      before(:each) { allow(File).to receive(:exist?).and_return(false) }

      it "raises a NoAccessToken error" do
        expect { subject }.
          to raise_error { FindGithubEmail::Errors::NoAccessToken }
      end
    end
  end

  describe ".github_access_token=" do
    subject { described_class.github_access_token = (access_token) }

    before(:each) do
      allow_any_instance_of(GraphQL::Client::Errors).
        to receive(:any?).
        and_return(!access_token_valid?)
    end

    let(:access_token_valid?) { true }
    let(:bad_token) { "bad token" }

    context "when there is already an access token set" do
      before(:each) do
        File.write(described_class::ACCESS_TOKEN_FILE_PATH, bad_token)
      end

      it "rewrites the access token file" do
        expect { subject }.
          to change { File.read(described_class::ACCESS_TOKEN_FILE_PATH) }.
          from(bad_token).
          to(access_token)
      end

      it "sets the access token" do
        subject
        expect(described_class.github_access_token).to eq(access_token)
      end
    end

    context "when no access token is already set" do
      it "sets the access token" do
        subject
        expect(described_class.github_access_token).to eq(access_token)
      end
    end

    context "when the access token is invalid" do
      let(:access_token_valid?) { false }

      it "raises an InvalidAccessToken error" do
        expect { subject }.
          to raise_error { FindGithubEmail::Errors::InvalidAccessToken }
      end
    end
  end
end
