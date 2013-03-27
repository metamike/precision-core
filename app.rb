require 'json'
require 'sinatra/base'

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

Dir[File.join(PROJECT_ROOT, "lib", "init", "**", "*.rb")].each do |file|
  require file
end

module Precision
module API

  class Server < Sinatra::Base

    set :environment, Env.get

    # CORS: https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS
    after do
      headers "Access-Control-Allow-Origin" => "*"
    end

  end

end
end

Dir[File.join(PROJECT_ROOT, "lib", "routes", "**", "*.rb")].each do |file|
  require file
end

