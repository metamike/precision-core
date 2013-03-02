PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))

task :default => ["precision:api:start"]

namespace :precision do

  namespace :api do

    desc "Start the API Server"
    task :start do
      sh "rackup #{File.join(PROJECT_ROOT, 'config.ru')}"
    end

  end

end
