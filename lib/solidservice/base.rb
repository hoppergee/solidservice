module SolidService
  class Base
 
    class State
      def initialize(state, data={})
        @state = state || :success
        @_data = (data || {}).with_indifferent_access
      end
   
      def success?
        @state == :success
      end
  
      def fail?
        @state == :fail
      end
  
      def method_missing(key)
        @_data[key]
      end
    end
  
    class << self
      def call(params={})
        begin
          service = new(params)
          service.call
          service.state

        rescue Success
          service.state

        rescue Failure
          service.state

        rescue => e
          service._fail(error: e)
        end
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

    # Internal use only
    def _fail(params={})
      @state = State.new(:fail, params)
    end

  end
end