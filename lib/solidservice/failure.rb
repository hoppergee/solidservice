module SolidService
  class Failure < StandardError
    attr_reader :service_result

    def initialize(message, params={})
      @service_result = params[:service_result]
      super(message)
    end
  end
end
