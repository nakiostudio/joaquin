require "bundler/gem_tasks"

task :watch do
  require 'listen'
  listener = Listen.to('lib/') do |modified, added, removed|
    puts `rake install`
  end
  listener.start
  sleep
end

