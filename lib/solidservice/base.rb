module SolidService
  class Base
  
    class << self

      def call(params={})
        service = new(params)
        service.call
        service.state

      rescue Success
        service.state

      rescue Failure
        service.state

      rescue => e
        service.fail(error: e)
        service.state
      end
  
      def call!(params={})
        state = call(params)
        return state unless state.fail?
  
        if state.error
          raise state.error
        else
          raise Error.new("Service failed", service_result: state)
        end
      end

    end
  
    attr_reader :params, :state
  
    def initialize(params)
      @params = (params || {}).with_indifferent_access
      @state = State.new(:success)
    end
  
    def call
      raise "Override please"
    end
  
    def success!(params={})
      @state = State.new(:success, params)
      raise Success.new
    end
  
    def fail!(params={})
      @state = State.new(:fail, params)
      raise Failure.new
    end

    def success(params={})
      @state = State.new(:success, params)
    end

    def fail(params={})
      @state = State.new(:fail, params)
    end

  end
end