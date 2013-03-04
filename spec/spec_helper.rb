require 'rack/test'
require 'rspec'
require 'sinatra'

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), "..", 'app')

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Precision::API::Server
end
