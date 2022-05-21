# frozen_string_literal: true

require "test_helper"

class SolidService::TestSuccess < ApplicationTest

  def test_success
    assert SolidService::Success.new.is_a?(StandardError)
  end

end
