# frozen_string_literal: true

require "find_github_email/errors"
require "find_github_email/github_access_token"

RSpec.describe FindGithubEmail::Finder do
  describe ".find" do
    subject { described_class.find(username) }

    let(:username) { "username" }
    let(:access_token_valid?) { true }
    let(:data) { Class.new }
    let(:email) { "email@domain.com" }
    let(:user_data) do
      {
        "email" => email,
        "repositories" => repositories(username, "name", email),
        "repositoriesContributedTo" => repositories("login", "name", "email"),
        "topRepositories" => repositories("login", "name", "email")
      }
    end

    before(:each) do
      allow_any_instance_of(GraphQL::Client::Errors).
        to receive(:any?).
        and_return(!access_token_valid?)
      allow(FindGithubEmail::GithubAccessToken).
        to receive(:github_access_token).
        and_return("access token")
      allow_any_instance_of(GraphQL::Client::Response).
        to receive(:data).
        and_return(data)
      allow(data).to receive(:user).and_return(data)
      allow(data).to receive(:data).and_return(user_data)
    end

    context "when the query returns errors" do
      let(:access_token_valid?) { false }

      it "raises an InvalidAccessToken error" do
        expect { subject }.
          to raise_error { FindGithubEmail::Errors::InvalidAccessToken }
      end
    end

    context "when there is no email data for a user" do
      let(:user_data) { {} }

      it "raises a NoGithubUser error" do
        expect { subject }.
          to raise_error { FindGithubEmail::Errors::NoGithubUser }
      end
    end

    def repositories(login, name, email)
      {
        "nodes" => [
          {
            "refs" => {
              "nodes" => [
                {
                  "target" => {
                    "author" => {
                      "user" => {
                        "login" => login
                      },
                      "name" => name,
                      "email" => email
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    end

    context "when there is one email for a user" do
      it "returns the email address" do
        expect(subject).to eq([email])
      end

      context "when the user's profile email is not set" do
        let(:user_data) { super().merge({ "email" => nil }) }

        it "returns the email address" do
          expect(subject).to eq([email])
        end
      end

      context "when the name matches, but login is not set" do
        let(:user_data) do
          super().merge(
            {
              "email" => nil,
              "repositories" => repositories("login", username, email)
            }
          )
        end

        it "returns the email address" do
          expect(subject).to eq([email])
        end
      end
    end

    context "when there are multiple emails for a user" do
      let(:other_email) { "other_email@other_domain.com" }
      let(:user_data) do
        super().merge(
          {
            "repositoriesContributedTo" =>
            repositories(username, "name", other_email)
          }
        )
      end

      it "returns the email address" do
        expect(subject).to eq([email, other_email])
      end
    end
  end
end
