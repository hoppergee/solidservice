# frozen_string_literal: true

require "test_helper"

class SolidService::TestBase < ApplicationTest

  def test_success_by_default
    klass :TestSuccessByDefaultService, SolidService::Base do
      def call
      end
    end

    state = TestSuccessByDefaultService.call(email: 'service@example.com')

    assert state.success?
    assert_nil state.email

    remove_klass :TestSuccessByDefaultService
  end

  def test_success
    klass :TestSuccessService, SolidService::Base do
      def call
        success!(email: params[:email])
      end
    end

    state = TestSuccessService.call(email: 'service@example.com')

    assert state.success?
    assert 'service@example.com', state.email

    remove_klass :TestSuccessService
  end

  def test_call_fail
    klass :TestFailService, SolidService::Base do
      def call
        fail!(email: params[:email])
      end
    end

    state = TestFailService.call(email: 'service@example.com')

    assert state.fail?
    assert 'service@example.com', state.email

    remove_klass :TestFailService
  end

  def test_call_fail_when_raise_error
    klass :TestFailOnRaiseErrorService, SolidService::Base do
      def call
        raise StandardError.new('Something wrong')
      end
    end

    state = TestFailOnRaiseErrorService.call(email: 'service@example.com')

    assert state.fail?
    assert 'Something wrong', state.error.message

    remove_klass :TestFailOnRaiseErrorService
  end

  def test_call_bang_success
    klass :TestSuccessService, SolidService::Base do
      def call
        success!(email: params[:email])
      end
    end

    state = TestSuccessService.call!(email: 'service@example.com')

    assert state.success?
    assert 'service@example.com', state.email

    remove_klass :TestSuccessService
  end

  def test_call_bang_fail
    klass :TestFailService, SolidService::Base do
      def call
        fail!(email: params[:email])
      end
    end

    begin
      TestFailService.call!(email: 'service@example.com')
    rescue => e
      assert e.is_a?(SolidService::Base::Failure)
      assert_equal "Service failed", e.message
      assert_equal 'service@example.com', e.service_result.email
    end

    remove_klass :TestFailService
  end

  def test_call_bang_fail_when_raise_error
    klass :TestFailOnRaiseErrorService, SolidService::Base do
      def call
        raise StandardError.new('Something wrong')
      end
    end

    error = assert_raises StandardError do
      TestFailOnRaiseErrorService.call!(email: 'service@example.com')
    end
    assert_equal "Something wrong", error.message

    remove_klass :TestFailOnRaiseErrorService
  end

end
