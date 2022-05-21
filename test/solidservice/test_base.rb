# frozen_string_literal: true

require "test_helper"

class SolidService::TestBase < ApplicationTest

  ######
  # Test .call
  ######

  it ".call - success by default" do
  
    klass :TestSuccessByDefaultService, SolidService::Base do
      def call
      end
    end

    state = TestSuccessByDefaultService.call(email: 'service@example.com')

    assert state.success?
    assert_nil state.email

    remove_klass :TestSuccessByDefaultService
  end

  it ".call with #success!" do
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

  it ".call with #fail!" do
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

  it ".call - fail on raising error" do
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

  it ".call! - success by default" do
    klass :TestSuccessByDefaultService, SolidService::Base do
      def call
      end
    end

    state = TestSuccessByDefaultService.call!(email: 'service@example.com')

    assert state.success?
    assert_nil state.email

    remove_klass :TestSuccessByDefaultService
  end

  it ".call! with success!" do
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

  it ".call! with fail!" do
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

  it ".call! - fail on raising error" do
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


  ######
  # Test the difference behavior of #success #fail #success! #fail!
  ######

  it "call #success twice" do
    klass :TestSuccessService, SolidService::Base do
      def call
        success(email: 'hi@example.com')

        success(email: params[:email])
      end
    end

    state = TestSuccessService.call(email: 'service@example.com')

    assert state.success?
    assert 'service@example.com', state.email

    remove_klass :TestSuccessService
  end

  it "call #success! twice" do
    klass :TestSuccessService, SolidService::Base do
      def call
        success!(email: 'hi@example.com')

        success!(email: params[:email])
      end
    end

    state = TestSuccessService.call(email: 'hi@example.com')

    assert state.success?
    assert 'service@example.com', state.email

    remove_klass :TestSuccessService
  end

  it "call #fail twice" do
    klass :TestFailService, SolidService::Base do
      def call
        fail(email: 'hi@example.com')
        fail(email: params[:email])
      end
    end

    state = TestFailService.call(email: 'service@example.com')

    assert state.fail?
    assert 'service@example.com', state.email

    remove_klass :TestFailService
  end

  it "call #fail! twice" do
    klass :TestFailService, SolidService::Base do
      def call
        fail!(email: 'hi@example.com')
        fail!(email: params[:email])
      end
    end

    state = TestFailService.call(email: 'hi@example.com')

    assert state.fail?
    assert 'service@example.com', state.email

    remove_klass :TestFailService
  end

  it "#fail then #success" do
    klass :TestFailService, SolidService::Base do
      def call
        fail(email: 'hi@example.com')
        success(email: params[:email])
      end
    end

    state = TestFailService.call(email: 'service@example.com')

    assert state.success?
    assert 'service@example.com', state.email

    remove_klass :TestFailService
  end

  it "#fail! then #success!" do
    klass :TestFailService, SolidService::Base do
      def call
        fail!(email: 'hi@example.com')
        success!(email: params[:email])
      end
    end

    state = TestFailService.call(email: 'hi@example.com')

    assert state.fail?
    assert 'service@example.com', state.email

    remove_klass :TestFailService
  end

  it "#success! then #fail!" do
    klass :TestFailService, SolidService::Base do
      def call
        success!(email: 'hi@example.com')
        fail!(email: params[:email])
      end
    end

    state = TestFailService.call(email: 'hi@example.com')

    assert state.success?
    assert 'service@example.com', state.email

    remove_klass :TestFailService
  end

end
