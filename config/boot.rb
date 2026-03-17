# frozen_string_literal: true

# Load Logger before Rails to prevent NameError in Ruby 3.1+
# See issue #492
require "logger"

require "yaml"
require "erb"

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

module Settings
  extend self

  CONFIG = YAML.load(ERB.new(File.read(File.expand_path("settings.yml", __dir__))).result)

  def method_missing(method_name)
    if method_name.to_s =~ /(\w+)\?$/
      CONFIG[Regexp.last_match(1)] == true
    else
      CONFIG[method_name.to_s]
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    key = method_name.to_s

    if key.end_with?("?")
      CONFIG.key?(key.delete_suffix("?")) || super
    else
      CONFIG.key?(key) || super
    end
  end
end
