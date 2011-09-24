class RailsBlogEngine::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
    copy_file "rails_blog_engine.rb", "config/initializers/rails_blog_engine.rb"
  end

  def add_route
    route 'mount RailsBlogEngine::Engine => "/blog"'
  end

  def copy_migrations
    # Normally, we'd just call 'rake
    # "rails_blog_engine:install:migrations"' to do this for us, but it's
    # much more difficult to test.  So we roll our own version.
    migrations = File.expand_path("../../../../../db/migrate/*.rb", __FILE__)
    Dir[migrations].each do |path|
      copy_file path, "db/migrate/#{File.basename(path)}"
    end
  end
end
