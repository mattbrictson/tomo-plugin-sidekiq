#!/usr/bin/env ruby

require "bundler/inline"
require "fileutils"
require "io/console"
require "open3"

gemfile do
  source "https://rubygems.org"
  gem "octokit", "~> 4.14"
end

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
def main
  assert_git_repo!
  git_meta = read_git_data

  plugin_name = ask(
    "Plugin name?",
    default: git_meta[:origin_repo_name].sub(/^tomo-plugin-/, "")
  )
  plugin_name.sub!(/^tomo-plugin-/, "")
  gem_name = "tomo-plugin-#{plugin_name}"
  gem_summary = ask(
    "Gem summary (< 60 chars)?", default: "#{plugin_name} tasks for tomo"
  )
  author_email = ask("Author email?", default: git_meta[:user_email])
  author_name = ask("Author name?", default: git_meta[:user_name])
  github_repo = ask("GitHub repository?", default: git_meta[:origin_repo_path])

  if ask_yes_or_no("Create GitHub labels?", default: "Y")
    puts
    puts "I need to ask for your GitHub credentials in order to create labels."
    puts "Don't worry, your GitHub credentials will NOT be saved."
    puts
    login = ask("GitHub username?", default: github_repo.split("/").first)
    password = ask("GitHub password?", echo: false)
    client = authenticate_github(login, password)
    create_labels(
      client,
      github_repo,
      ["⚠️ Breaking", "d12d1b", "Introduces a backwards-incompatible change"],
      ["🐛 Bug Fix", "c0fc80", "Fixes a bug"],
      ["📚 Docs", "bfdadc", "Improves documentation"],
      ["✨ Feature", "ba1ecc", "Adds a new feature"],
      ["🏠 Housekeeping", "ccccff", "Non-user facing cleanup and maintenance"]
    )
  end

  git "mv", ".github/workflows/push.yml.dist", ".github/workflows/push.yml"

  FileUtils.mkdir_p "lib/#{as_path(gem_name)}"
  FileUtils.mkdir_p "test/#{as_path(gem_name)}"

  ensure_executable "bin/console"
  ensure_executable "bin/setup"

  replace_in_file "LICENSE.txt",
                  "Example Owner" => author_name

  replace_in_file "Rakefile",
                  "example.gemspec" => "#{gem_name}.gemspec",
                  "mattbrictson/tomo-plugin" => github_repo

  replace_in_file "README.md",
                  "mattbrictson/tomo-plugin" => github_repo,
                  "example" => plugin_name,
                  "plugin_name" => plugin_name.tr("-", "_"),
                  "replace_with_gem_name" => gem_name,
                  /\A.*<!-- END FRONT MATTER -->\n+/m => ""

  replace_in_file "CHANGELOG.md",
                  "mattbrictson/tomo-plugin" => github_repo

  replace_in_file "CODE_OF_CONDUCT.md",
                  "owner@example.com" => author_email

  replace_in_file "bin/console", "tomo/plugin/example" => as_path(gem_name)

  replace_in_file "example.gemspec",
                  "mattbrictson/tomo-plugin" => github_repo,
                  '"Example Owner"' => author_name.inspect,
                  '"owner@example.com"' => author_email.inspect,
                  '"example"' => gem_name.inspect,
                  "example/version" => "#{as_path(plugin_name)}/version",
                  "Example::VERSION" => "#{as_module(plugin_name)}::VERSION",
                  /summary\s*=\s*("")/ => gem_summary.inspect

  git "mv", "example.gemspec", "#{gem_name}.gemspec"

  replace_in_file "lib/tomo/plugin/example.rb",
                  "example" => as_path(plugin_name),
                  "plugin_name" => plugin_name.tr("-", "_"),
                  "Example" => as_module(plugin_name)

  git "mv", "lib/tomo/plugin/example.rb", "lib/#{as_path(gem_name)}.rb"

  replace_in_file "lib/tomo/plugin/example/version.rb", <<~MODULE => ""
    module Tomo
      module Plugin
      end
    end

  MODULE

  %w[helpers tasks version].each do |file|
    replace_in_file "lib/tomo/plugin/example/#{file}.rb",
                    "Example" => as_module(plugin_name),
                    "example" => plugin_name
    git "mv",
        "lib/tomo/plugin/example/#{file}.rb",
        "lib/#{as_path(gem_name)}/#{file}.rb"
  end

  reindent_module "lib/#{as_path(gem_name)}.rb"
  reindent_module "lib/#{as_path(gem_name)}/version.rb"

  replace_in_file "test/tomo/plugin/example_test.rb",
                  "Example" => as_module(plugin_name)
  git "mv",
      "test/tomo/plugin/example_test.rb",
      "test/#{as_path(gem_name)}_test.rb"

  %w[helpers_test tasks_test].each do |file|
    replace_in_file "test/tomo/plugin/example/#{file}.rb",
                    "Example" => as_module(plugin_name)
    replace_in_file "test/tomo/plugin/example/#{file}.rb",
                    "example" => plugin_name
    git "mv",
        "test/tomo/plugin/example/#{file}.rb",
        "test/#{as_path(gem_name)}/#{file}.rb"
  end

  replace_in_file "test/test_helper.rb",
                  'require "tomo/plugin/example"' =>
                    %Q(require "#{as_path(gem_name)}")

  git "rm", "rename_template.rb"

  puts <<~MESSAGE

    All set!

    The project has been renamed to "#{gem_name}".
    Review the changes and then run:

      git commit && git push

  MESSAGE
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength

def assert_git_repo!
  return if File.file?(".git/config")

  warn("This doesn't appear to be a git repo. Can't continue. :(")
  exit(1)
end

def git(*args)
  sh! "git", *args
end

def ensure_executable(path)
  return if File.executable?(path)

  FileUtils.chmod 0o755, path
  git "add", path
end

def sh!(*args)
  puts ">>>> #{args.join(' ')}"
  stdout, status = Open3.capture2(*args)
  raise("Failed to execute: #{args.join(' ')}") unless status.success?

  stdout
end

def remove_line(file, pattern)
  text = IO.read(file)
  text = text.lines.filter.grep_v(pattern).join
  IO.write(file, text)
  git "add", file
end

def ask(question, default: nil, echo: true)
  prompt = "#{question} "
  prompt << "[#{default}] " unless default.nil?
  print prompt
  answer = if echo
             $stdin.gets.chomp
           else
             $stdin.noecho(&:gets).tap { $stdout.print "\n" }.chomp
           end
  answer.to_s.strip.empty? ? default : answer
end

def ask_yes_or_no(question, default: "N")
  default = default == "Y" ? "Y/n" : "y/N"
  answer = ask(question, default: default)

  answer != "y/N" && answer.match?(/^y/i)
end

def read_git_data
  return {} unless git("remote", "-v").match?(/^origin/)

  origin_url = git("remote", "get-url", "origin").chomp
  origin_repo_path = origin_url[%r{[:/]([^/]+/[^/]+)(?:\.git)$}, 1]

  {
    origin_repo_name: origin_repo_path.split("/").last,
    origin_repo_path: origin_repo_path,
    user_email: git("config", "user.email").chomp,
    user_name: git("config", "user.name").chomp
  }
end

def replace_in_file(path, replacements)
  contents = IO.read(path)
  replacements.each do |regexp, text|
    contents.gsub!(regexp) do |match|
      next text if Regexp.last_match(1).nil?

      match[regexp, 1] = text
      match
    end
  end

  IO.write(path, contents)
  git "add", path
end

def as_path(gem_name)
  gem_name.tr("-", "/")
end

def as_module(gem_name)
  parts = gem_name.split("-")
  parts.map do |part|
    part.gsub(/^[a-z]|_[a-z]/) { |str| str.chars.last.upcase }
  end.join("::")
end

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
def reindent_module(path)
  contents = IO.read(path)
  preamble = contents[/\A(.*)^(?:module|class)/m, 1]
  contents.sub!(preamble, "") if preamble

  namespace_mod = contents[/(?:module|class) (\S+)/, 1]
  return unless namespace_mod.include?("::")

  contents.sub!(namespace_mod, namespace_mod.split("::").last)
  namespace_mod.split("::")[0...-1].reverse_each do |mod|
    contents = "module #{mod}\n#{contents.gsub(/^/, '  ')}end\n"
  end

  contents.gsub!(/^\s+$/, "")
  IO.write(path, [preamble, contents].join)
  git "add", path
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength

def authenticate_github(login, password)
  octokit = Octokit::Client.new(login: login, password: password, netrc: false)
  octokit.user
  GithubClient.new(octokit)
rescue Octokit::OneTimePasswordRequired
  token = ask("2FA token?")
  GithubClient.new(octokit, otp_token: token)
end

def create_labels(client, github_repo, *labels)
  labels.each do |name, color, description|
    client.add_label(github_repo, name, color, description)
  end

  puts "Created labels: #{labels.map(&:first).join(', ')}"
end

class GithubClient
  def initialize(octokit, otp_token: nil)
    @octokit = octokit
    @otp_token = otp_token
  end

  def add_label(repo, name, color, description)
    octokit.add_label(
      repo,
      name,
      color,
      auth_options.merge(
        description: description,
        accept: "application/vnd.github.symmetra-preview+json"
      )
    )
  end

  private

  attr_reader :octokit, :otp_token

  def auth_options
    return {} if otp_token.nil?

    { headers: { "X-GitHub-OTP" => otp_token } }
  end
end

main if $PROGRAM_NAME == __FILE__
