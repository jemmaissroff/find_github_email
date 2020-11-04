# frozen_string_literal: true

# rubocop:disable Style/Documentation
module FindGithubEmail
  module Errors
    class Error < RuntimeError
      def initialize(access_token: nil, username: nil)
        @access_token =  access_token
        @username = username
        super
      end

      HELP_OUTPUT = "\nFor help, run: `find_github_email --help`"
    end

    class InvalidAccessToken < Error
      def message
        "Oops, the access token `#{@access_token}` is invalid #{HELP_OUTPUT}"
      end
    end

    class NoAccessToken < Error
      def message
        "Oops, no access token set #{HELP_OUTPUT}"
      end
    end

    class NoGithubUser < Error
      def message
        "Ooops, there is no GitHub user with username " \
          "#{@username} #{HELP_OUTPUT}"
      end
    end

    class NoEmailData < Error
      def message
        "#{@username} has no email data in GitHub"
      end
    end

    class NoUsernameProvided < Error
      def message
        "Ooops, no username provided!#{HELP_OUTPUT}"
      end
    end
  end
end
# rubocop:enable Style/Documentation
