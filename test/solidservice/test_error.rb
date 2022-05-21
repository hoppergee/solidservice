# frozen_string_literal: true

require "test_helper"

class SolidService::TestError < ApplicationTest

  def test_error
    assert SolidService::Error.new('something wrong').is_a?(StandardError)
  end

  def test_service_result
    fail_state = SolidService::Base::State.new(:fail)
    error = SolidService::Error.new('something wrong', service_result: fail_state)
    assert_equal "something wrong", error.message
    assert_equal fail_state, error.service_result
  end

end
