# This is a strictly optional dependency.
require "pygments" rescue nil

module RailsBlogEngine::Filters
  # Syntax highlighting for code blocks.
  class Code < Base
    register_filter :code

    def process(text, options)
      if defined?(Pygments)
        Pygments.new(text, options[:lang] || 'ruby').colorize
      else
        raise "Install pygments-gem to enable syntax highlighting"
      end
    end
  end
end
