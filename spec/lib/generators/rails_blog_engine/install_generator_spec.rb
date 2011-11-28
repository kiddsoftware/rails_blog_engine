require "spec_helper.rb"
require "generator_spec/test_case"
require "generators/rails_blog_engine/install/install_generator"

describe RailsBlogEngine::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../../../tmp", __FILE__)

  # Create a file with the specified contents in our fake application tree.
  # This is faster than generating a real application every time we test.
  def create_file(path, contents)
    full_path = ::File.join(destination_root, path)
    mkdir_p(::File.dirname(full_path))
    ::File.open(full_path, 'w') {|f| f.write(contents) }
  end

  def prepare_destination
    super
    create_file('config/routes.rb', <<EOD)
Dummy::Application.routes.draw do
end
EOD
    create_file('app/assets/stylesheets/application.css', <<EOD)
/*
 *= require_self
 *= require_tree .
*/
EOD
    create_file('app/assets/javascripts/application.js', <<EOD)
//= require jquery
//= require jquery_ujs
//= require_tree .
EOD
  end

  before do
    prepare_destination
    run_generator
  end

  it "generates the expected files" do
    destination_root.should have_structure {
      directory "app" do
        directory "assets" do
          directory "javascripts" do
            file "application.js" do
              contains "//= require rails_blog_engine"
            end
          end
          directory "stylesheets" do
            file "application.css" do
              contains " *= require rails_blog_engine"
            end
            directory "rails_blog_engine" do
              file "_config.css.scss"
              file "layout.css.scss"
            end
          end
        end
        directory "views" do
          directory "layouts" do
            directory "rails_blog_engine" do
              file "_sidebar.html.haml"
            end
          end
        end
      end
      directory "config" do
        file "routes.rb" do
          contains 'mount RailsBlogEngine::Engine => "/blog"'
        end
        directory "initializers" do
          file "rails_blog_engine.rb"
        end
        directory "locales" do
          file "rails_blog_engine.en.yml"
        end
      end
      directory "db" do
        directory "migrate" do
          # We don't need to test every single one of these--just make sure
          # a couple are copied over, and the rest should be OK.
          file "20110912153527_create_rails_blog_engine_posts.rb"
          file "20110913190319_add_fields_to_rails_blog_engine_post.rb"
        end
      end
    }
  end
end
