# frozen_string_literal: true

require "find_github_email"

module FindGithubEmail
  # Allows a user to set and retrieve their GitHub access token to use the API
  class GithubAccessToken
    # Stores a user's access token at this file path
    ACCESS_TOKEN_FILE_PATH =
      File.expand_path("~/.find_github_email_access_token")

    def self.github_access_token
      raise Errors::NoAccessToken unless File.exist?(ACCESS_TOKEN_FILE_PATH)

      @github_access_token ||= File.read(ACCESS_TOKEN_FILE_PATH)
    end

    def self.github_access_token=(access_token)
      if Client.query(HelloQuery, context: { bearer: access_token }).errors.any?
        raise Errors::InvalidAccessToken.new(access_token: access_token)
      else
        File.write(ACCESS_TOKEN_FILE_PATH, access_token)
        @github_access_token = access_token
        puts "Successfully set GitHub access token"
      end
    end
  end
end
