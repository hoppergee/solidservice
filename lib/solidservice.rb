# frozen_string_literal: true

require_relative "solidservice/version"
require "active_support/core_ext/hash/indifferent_access"

module SolidService
  class Error < StandardError; end

  autoload :Base, "solidservice/base"
end
