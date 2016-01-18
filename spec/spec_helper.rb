$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hola'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
