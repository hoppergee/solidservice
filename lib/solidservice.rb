# frozen_string_literal: true

require_relative "solidservice/version"
require "active_support/core_ext/hash/indifferent_access"

module SolidService
  autoload :Error, "solidservice/error"
  autoload :Failure, "solidservice/failure"
  autoload :Success, "solidservice/success"

  autoload :Base, "solidservice/base"
end
