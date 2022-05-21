# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter "/test"
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "solidservice"

require "minitest/autorun"
require 'debug'

class ApplicationTest < Minitest::Test

  def klass(class_name, parent=Object, &block)
    klass = Class.new(parent)
    klass.class_exec(&block)
    self.class.const_set class_name, klass
  end

  def remove_klass(klass)
    self.class.send(:remove_const, klass)
  end

end