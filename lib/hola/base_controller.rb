module Hola
  class BaseController
    attr_reader :env, :request, :params

    def initialize(env, request=nil, params=nil)
      @env      = env
      @request  = request
      @params   = params
    end
  end
end
