#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'RailsBlogEngine'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'


Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc "Verify against specifications"
RSpec::Core::RakeTask.new do |t|
end

# Copy database tables from development to test.
task :spec => 'app:db:test:load'

task :default => :spec

# This code was copied from the Rails source, and is under an MIT license.
desc 'Print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'
task :routes => 'app:environment' do

  Rails.application.reload_routes!
  all_routes = RailsBlogEngine::Engine.routes.routes
  prefix = RailsBlogEngine::Engine.routes.url_helpers.blog_path.sub(/\/\z/, '')

  if ENV['CONTROLLER']
    all_routes = all_routes.select{ |route| route.defaults[:controller] == ENV['CONTROLLER'] }
  end

  routes = all_routes.collect do |route|

    reqs = route.requirements.dup
    rack_app = route.app unless route.app.class.name.to_s =~ /^ActionDispatch::Routing/

    endpoint = rack_app ? rack_app.inspect : "#{reqs[:controller]}##{reqs[:action]}"
    constraints = reqs.except(:controller, :action)

    reqs = endpoint == '#' ? '' : endpoint

    unless constraints.empty?
      reqs = reqs.empty? ? constraints.inspect : "#{reqs} #{constraints.inspect}"
    end

    {:name => route.name.to_s, :verb => route.verb.to_s, :path => prefix + route.path, :reqs => reqs}
  end

   # Skip the route if it's internal info route
  routes.reject! { |r| r[:path] =~ %r{/rails/info/properties|^/assets} }

  name_width = routes.map{ |r| r[:name].length }.max
  verb_width = routes.map{ |r| r[:verb].length }.max
  path_width = routes.map{ |r| r[:path].length }.max

  routes.each do |r|
    puts "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:path].ljust(path_width)} #{r[:reqs]}"
  end
end
