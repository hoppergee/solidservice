module SolidService
  class State
    def initialize(state = :success, data={})
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
end
