require 'rspec/core/rake_task'

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

task default: [:start]

desc "Run Tests"
task :spec do
  task = RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = ['-cfs']
  end
end

desc "Start the API Server"
task :start do
  sh "rackup #{File.join(PROJECT_ROOT, 'config.ru')}"
end

desc "Run a console session"
task :console do
  require 'irb'
  ARGV.clear

  $env = :development

  Dir[File.join(PROJECT_ROOT, "lib", "precision", "api", "init", "*.rb")].each do |file|
    require file
  end

  IRB.start
end
