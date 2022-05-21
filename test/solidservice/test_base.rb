# frozen_string_literal: true

require "test_helper"

class SolidService::TestBase < ApplicationTest

  ######
  # Test .call
  ######

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

  def test_success_in_call
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

  def test_fail_in_call
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

  def test_failure_on_raising_error_in_call
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

  ######
  # Test .call!
  ######

  def test_success_by_default_in_call!
    klass :TestSuccessByDefaultService, SolidService::Base do
      def call
      end
    end

    state = TestSuccessByDefaultService.call!(email: 'service@example.com')

    assert state.success?
    assert_nil state.email

    remove_klass :TestSuccessByDefaultService
  end

  def test_success_in_call!
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

  def test_fail_in_call!
    klass :TestFailService, SolidService::Base do
      def call
        fail!(email: params[:email])
      end
    end

    begin
      TestFailService.call!(email: 'service@example.com')
    rescue => e
      assert e.is_a?(SolidService::Error)
      assert_equal "Service failed", e.message
      assert_equal 'service@example.com', e.service_result.email
    end

    remove_klass :TestFailService
  end

  def test_failure_on_raising_error_in_call!
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
