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
    copy_matching_files_from_gem('db/migrate/*.rb')
  end

  def copy_locales
    copy_matching_files_from_gem('config/locales/rails_blog_engine.*.yml')
  end

  def copy_sidebar
    copy_matching_files_from_gem('app/views/layouts/rails_blog_engine/_sidebar.html.haml')
  end

  def copy_stylesheets
    copy_matching_files_from_gem('app/assets/stylesheets/rails_blog_engine/_config.css.scss')
    copy_matching_files_from_gem('app/assets/stylesheets/rails_blog_engine/layout.css.scss')
  end

  def register_javascripts
    in_root do
      append_file("app/assets/javascripts/application.js",
                  "//= require rails_blog_engine\n",
                  :before => /^\/\/= require/)
    end
  end

  def register_stylesheets
    in_root do
      inject_into_file("app/assets/stylesheets/application.css",
                       " *= require rails_blog_engine\n",
                       :before => /^\*\//)
    end
  end

  private

  def gem_path(path)
    File.expand_path("../../../../../#{path}", __FILE__)
  end

  def copy_matching_files_from_gem(pattern)
    matches = gem_path(pattern)
    Dir[matches].each do |path|
      copy_file path, "#{File.dirname(pattern)}/#{File.basename(path)}"
    end
  end
end
