PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))

task default: ["precision:api:start"]

namespace :precision do

  namespace :api do

    desc "Start the API Server"
    task :start do
      sh "rackup #{File.join(PROJECT_ROOT, 'config.ru')}"
    end

    desc "Run a console session"
    task :console do
      require 'irb'
      ARGV.clear

      $LOAD_PATH << File.join(PROJECT_ROOT, "lib")
      $env = :development
 
      Dir[File.join(PROJECT_ROOT, "lib", "precision", "api", "init", "*.rb")].each do |file|
        require file
      end

      IRB.start
    end

  end

end

