require 'mongoid'

if defined? $env
  puts Mongoid.load!(File.join(PROJECT_ROOT, "config", "mongoid.yml"), ENV)
else
  Mongoid.load!(File.join(PROJECT_ROOT, "config", "mongoid.yml"))
end
