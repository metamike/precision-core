require 'mongoid'

if defined? $env
  Mongoid.load!(File.join(PROJECT_ROOT, "config", "mongoid.yml"), ENV)
else
  Mongoid.load!(File.join(PROJECT_ROOT, "config", "mongoid.yml"))
end
