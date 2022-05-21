# frozen_string_literal: true

require "test_helper"

class SolidService::TestFailure < ApplicationTest

  def test_failure
    assert SolidService::Failure.new.is_a?(StandardError)
  end

end
