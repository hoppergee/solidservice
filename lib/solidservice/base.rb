module SolidService
  class Base
 
    class State
      def initialize(state, data={})
        @state = state || :pending
        @_data = (data || {}).with_indifferent_access
      end
  
      def pending?
        @state == :pending
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
        service = new(params)
        service.call
        service.success! if service.state.pending?
        service.state
      rescue => e
        service.fail!(error: e)
      end
  
      def call!(params={})
        state = call(params)
        return state unless state.fail?
  
        if state.error
          raise state.error
        else
          raise Failure.new("Service failed", service_result: state)
        end
      end
    end
  
    attr_reader :params, :state
  
    def initialize(params)
      @params = (params || {}).with_indifferent_access
      @state = State.new(:pending)
    end
  
    def call
      raise "Override please"
    end
  
    def success!(params={})
      @state = State.new(:success, params)
    end
  
    def fail!(params={})
      @state = State.new(:fail, params)
    end

  end
end