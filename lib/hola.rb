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

      def get(route, target=nil, &block)
        if block_given?
          routes[route] = { block: block }
        else
          # { "/" => { :controller=>"landing", :action=>"index" } }
          routes[route] = target_to_controller_and_action(target)
        end
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

    def call(env)
      # get route hash
      route = route(env)
      # raise exception when we can't find route
      raise CantFindRouteException.new("No route for: #{env['PATH_INFO']}") if route.nil?
      # choose between block and simple routes
      if route[:block]
        text = route[:block].call
      else
        controller = get_controller_class(route[:controller]).new(env)
        text = controller.send(route[:action])
      end


      [200, { 'Content-Type' => 'text/html' }, [text]]
    end

    def route(env)
      self.class.routes[env['PATH_INFO']]
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
