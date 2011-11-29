module RailsBlogEngine
  class Engine < Rails::Engine
    isolate_namespace RailsBlogEngine

    # Define some initialization parameters and their default values.
    config.rails_blog_engine = ActiveSupport::OrderedOptions.new
    config.rails_blog_engine.layout = 'application'

    config.to_prepare do
      ::ApplicationHelper.class_eval do
        # Returns the current object.  This can be called from a layout or
        # view used with rails_blog_engine to access the containing
        # application's helpers.
        def app_helpers
          self
        end
      end
    end
  end
end
