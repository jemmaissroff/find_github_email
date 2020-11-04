# frozen_string_literal: true

require "find_github_email/client"

module FindGithubEmail
  HelloQuery = Client.parse <<-"GRAPHQL"
    {
      viewer {
        login
      }
    }
  GRAPHQL

  EmailQuery = Client.parse <<-"GRAPHQL"
    query($username: String!) {
      user(login: $username) {
        email
        repositories(first: 100) {
          ...userFields
        }
        repositoriesContributedTo(first: 100) {
          ...userFields
        }
        topRepositories(
          first: 100,
          orderBy: {field:UPDATED_AT, direction:ASC}
        ) {
          ...userFields
        }
      }
    }

    fragment userFields on RepositoryConnection {
      nodes {
        refs(refPrefix: "refs/heads/", first: 100) {
          nodes {
            target {
              ... on Commit {
                author {
                  email
                  name
                  user {
                    login
                  }
                }
              }
            }
          }
        }
      }
    }
  GRAPHQL
end
