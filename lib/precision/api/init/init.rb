require 'mongoid'

class Env

  def self.get
    ENV['RACK_ENV'].nil? ? :development : ENV['RACK_ENV'].to_sym
  end

end

Mongoid.load!(File.join(PROJECT_ROOT, "config", "mongoid.yml"), Env.get)
