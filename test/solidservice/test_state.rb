# frozen_string_literal: true

require "test_helper"

class SolidService::TestState < ApplicationTest

  it "test success by default" do
    state = SolidService::State.new
    assert state.success?
  end

  it "test success state" do
    state = SolidService::State.new(:success)
    assert state.success?
  end

  it "test fail state" do
    state = SolidService::State.new(:fail)
    assert state.fail?
  end

  it 'test extra data' do
    state = SolidService::State.new(:fail, a: 1, b: 2)
    assert state.fail?
    assert 1, state.a
    assert 2, state.b
  end

end
