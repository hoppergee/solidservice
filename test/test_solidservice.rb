# frozen_string_literal: true

require "test_helper"

class TestSolidService < ApplicationTest

  def test_that_it_has_a_version_number
    refute_nil ::SolidService::VERSION
  end

end
