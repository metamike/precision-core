require 'json'
require 'sinatra'

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

Dir[File.join(PROJECT_ROOT, "lib", "precision", "api", "init", "*.rb")].each do |file|
  require file
end

module Precision
module API

  class Server < Sinatra::Base

    set :environment, Env.get

  end

end
end

Dir[File.join(PROJECT_ROOT, "lib", "precision", "api", "routes", "**", "*.rb")].each do |file|
  require file
end

