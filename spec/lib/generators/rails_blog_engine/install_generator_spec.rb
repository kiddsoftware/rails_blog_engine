require "spec_helper.rb"
require "generator_spec/test_case"
require "generators/rails_blog_engine/install/install_generator"

describe RailsBlogEngine::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../../../tmp", __FILE__)

  def prepare_destination
    super
    routes_file = ::File.join(destination_root, 'config', 'routes.rb')
    mkdir_p(::File.dirname(routes_file))
    ::File.open(routes_file, 'w') {|f| f.write(<<EOD) }
Dummy::Application.routes.draw do
end
EOD
  end

  before do
    prepare_destination
    run_generator
  end

  it "generates the expected files" do
    destination_root.should have_structure {
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
