# frozen_string_literal: true

require_relative "lib/find_github_email/version"

Gem::Specification.new do |spec|
  spec.name        = "find_github_email"
  spec.version     = FindGithubEmail::VERSION
  spec.authors     = ["Jemma Issroff"]
  spec.date        = "2020-10-04"
  spec.summary     = "The warmest start to a cold email"
  spec.homepage    = "http://github.com/jemmaissroff/find_github_email"
  spec.license = "MIT"
  spec.description =  <<-DESCRIPTION
    Find GitHub Email is a gem to find any GitHub user's email addresses based
    on their commit history.
  DESCRIPTION
  spec.email = "jemmaissroff@gmail.com"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")
  spec.executables = ["find_github_email"]

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(spec)/})
  end
  spec.require_paths = ["lib"]
end
