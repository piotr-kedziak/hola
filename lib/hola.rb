require 'hola/version'

# doc...
module Hola
  class Application
    def call(env)
      klass, action = controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(action)
      [200, { 'Content-Type' => 'text/html' }, [text]]
    end

    def controller_and_action(env)
      _, controller, action, _after = env['PATH_INFO'].split('/', 4)
      # default controller and action names
      controller = 'Home'   if controller.nil? || controller == ''
      action     = 'index'  if action.nil? || action == ''

      controller = controller.capitalize  # "Home"
      controller += 'Controller'          # "HomeController"

      [Object.const_get(controller), action]
    end
  end

  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end
  end

  # example:....
  # class HomeController < Hola::Controller
  #   def index
  #     'Hola! espanioles!!!!!!'
  #   end
  # end
end
