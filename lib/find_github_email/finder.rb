# frozen_string_literal: true

require "find_github_email"

module FindGithubEmail
  # Finds a user's GitHub email addres by their username using GitHub's
  # GrapQL API
  class Finder
    def self.find(username)
      response = Client.query(
        EmailQuery,
        variables: { username: username },
        context: { bearer: GithubAccessToken.github_access_token }
      )

      raise Errors::InvalidAccessToken if response.errors.any?

      data = response.data.user&.data

      raise Errors::NoGithubUser.new(username: username) unless data

      # See spec/find_github_email/finder_spec.rb for examples of what the data
      # format looks like
      found_emails =
        ([data["email"]] +
         find_emails(data["repositories"], username) +
         find_emails(data["repositoriesContributedTo"], username) +
         find_emails(data["topRepositories"], username)).
        uniq.
        compact.
        reject { |s| s == "" || s =~ /noreply.github.com/ }

      raise Errors::NoEmailData.new(username: username) if found_emails.empty?

      found_emails
    end

    def self.find_emails(data, username)
      username = username.downcase
      data["nodes"].compact.flat_map do |node|
        node["refs"]["nodes"].flat_map do |sub_node|
          author = sub_node["target"]["author"]
          login = author["user"]&.[]"login"
          if [login, author["name"]].compact.map(&:downcase).include?(username)
            author["email"]
          end
        end
      end
    end
  end
end
