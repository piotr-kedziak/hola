require 'hola/version'
require 'hola/base_controller'

# doc...
module Hola
  class Application
    class << self
      @@routes = {}

      def routes
        @@routes
      end

      def get(route, target)
        # { "/" => { :controller=>"landing", :action=>"index" } }
        routes[route] = target_to_controller_and_action(target)
      end

      def target_to_controller_and_action(target)
        controller, action, _after = target.split('/', 3)
        # route must have action and
        raise RouteNoActionException if action.nil? || action == ''
        raise RouteNoControllerException if controller.nil? || controller == ''

        { controller: controller, action: action }
      end
    end

    def call(env)
      controller, action = route(env)
      controller = get_controller_class(controller).new(env)
      text = controller.send(action)
      [200, { 'Content-Type' => 'text/html' }, [text]]
    end

    def route(env)
      controller, action = controller_and_action(env)
      route = self.class.routes[env['PATH_INFO']]
      # raise exception when we can't find route
      raise CantFindRouteException.new("No route for: #{env['PATH_INFO']}") if route.nil?

      [route[:controller], route[:action]]
    end

    def controller_and_action(env)
      _, controller, action, _after = env['PATH_INFO'].split('/', 4)
      # default controller and action names
      controller = 'Home'   if controller.nil? || controller == ''
      action     = 'index'  if action.nil? || action == ''

      [controller, action]
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
