module RailsBlogEngine::Filters
  # A modular text filter that is applied to blog text before markdown
  # processing.
  class Base
    # Override this method to transform +text+, using any supplied
    # +arguments+.
    def process(text, arguments)
      raise "Please override #{self.class.name}#process"
    end

    class << self
      def register_filter(name)
        RailsBlogEngine::Filters.register_filter(name, self)
      end
    end
  end
end
