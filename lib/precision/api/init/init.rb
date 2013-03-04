require 'mongoid'

class Env

  def self.get
    ENV['RACK_ENV'].to_sym || :development
  end

end

Mongoid.load!(File.join(PROJECT_ROOT, "config", "mongoid.yml"), Env.get)
