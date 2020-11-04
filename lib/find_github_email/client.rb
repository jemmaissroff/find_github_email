# frozen_string_literal: true

require "graphql/client/http"
require "graphql/client"

# Creates a GraphQL client to connect to GitHub's API
module FindGithubEmail
  Client ||= GraphQL::Client.new(
    execute: GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
      def headers(context)
        {
          "Authorization":
          "Bearer #{context[:bearer]}"
        }
      end
    end
  )
end
