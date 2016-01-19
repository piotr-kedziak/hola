require 'hola/version'
require 'hola/base_controller'

# doc...
module Hola
  class Application
    attr_reader :request
    class << self
      @@routes = []

      def routes
        @@routes
      end

      # define route with method
      def define_route(method, path, target=nil, &block)
        route_def = {}
        # choose action for block and no-block routes
        if block_given?
          route_def = { block: block }
        else
          # { "/" => { :controller=>"landing", :action=>"index" } }
          route_def = target_to_controller_and_action(target)
        end
        # add method and params symbols
        route_def.merge!(
          match: get_math_for_route(path),
          method: method,
          params: process_params(path)
        )
        # add route to routes hash
        routes.push(route_def)
      end

      # define GET route
      def get(path, target=nil, &block)
        define_route(:get, path, target, &block)
      end

      def post(path, target=nil, &block)
        define_route(:post, path, target, &block)
      end

      # define resource name
      def resource(name)
        get("/#{name}", "#{name}/index")
        get("/#{name}/new", "#{name}/new")
        get("/#{name}/show/:id", "#{name}/show")
        get("/#{name}/edit", "#{name}/edit")
        post("/#{name}/update", "#{name}/update")
        post("/#{name}/create", "#{name}/create")
        get("/#{name}/delete", "#{name}/delete")
      end

      # find params names in route path like users/:id
      def process_params(path)
        # find symbols: "users/show/:id/:name" will give us ["users/show", "id", "name"]
        params = path.split(/\/:/)
        # first element is path "users/show"
        params.shift
        # return params
        params
      end

      def get_math_for_route(path)
        return /^#{path}$/ unless path =~ /\/:/
        /^#{get_path_without_params(path)}\/*/
      end

      def get_path_without_params(path)
        path.split(/\/:/).shift
      end

      def target_to_controller_and_action(target)
        controller, action, _after = target.split('/', 3)
        # route must have action and controller
        if action.nil? || action == ''
          raise RouteNoActionException.new('Route must have action!')
        end
        if controller.nil? || controller == ''
          raise RouteNoControllerException.new('Route must have controller!')
        end

        { controller: controller, action: action }
      end
    end

    def get_params_for_route(path, route)
      params = {}
      params_array = path.split(route[:match])
      params_array.shift
      params_array.each_with_index do |e, i|
        params[route[:params][i].to_sym] = e
      end
      params
    end

    def call(env)
      @request = Rack::Request.new(env)

      # get route hash
      route = route(env)
      # raise exception when we can't find route
      if route.nil?
        raise CantFindRouteException.new("No route for: #{env['REQUEST_METHOD']}: #{env['PATH_INFO']}")
      end

      params = nil
      # insert params into controller
      unless route[:params].nil? || route[:params].empty?
        params = get_params_for_route(env['PATH_INFO'], route)
      end

      # choose between block and simple routes
      if route[:block]
        text = route[:block].call(request)
      else
        controller = get_controller_class(route[:controller]).new(env, request, params)
        text = controller.send(route[:action])
      end

      [200, { 'Content-Type' => 'text/html' }, [text]]
    end

    def route(env)
      find_route(env['REQUEST_METHOD'], env['PATH_INFO'])
    end

    def find_route(method, path)
      # does path contain params string (like users/show/:id) ?
      can_be_this_route = self.class.routes.map do |route|
        return route unless (path =~ route[:match]).nil?
      end

      return nil if can_be_this_route.nil?

      can_be_this_route if can_be_this_route[:method].to_s == method.downcase
    end

    def controller_to_class(controller)
      controller = controller.capitalize  # "Home"
      controller += 'Controller'          # "HomeController"
    end

    def get_controller_class(controller)
      Object.const_get(controller_to_class(controller))
    end
  end

  class CantFindRouteException < StandardError
  end

  class RouteNoActionException < StandardError
  end

  class RouteNoControllerException < StandardError
  end
end
