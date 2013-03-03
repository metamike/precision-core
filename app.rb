require 'sinatra'

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

Dir[File.join(PROJECT_ROOT, "lib", "precision", "api", "init", "*.rb")].each do |file|
  require file
end

module Precision

  class API < Sinatra::Base

    get '/' do
      "Why, hello!"
    end

  end

end
