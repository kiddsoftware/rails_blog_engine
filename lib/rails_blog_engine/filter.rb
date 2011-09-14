module RailsBlogEngine
  class Filter

    class << self
      FILTERS = {}

      # Register a filter class to be used by #apply_all_to.
      def register_filter(name)
        FILTERS[name] = new
      end

      # Look up a registered filter class.
      def for(name)
        FILTERS[name]
      end

      # Apply all registered filters to the specified text.
      def apply_all_to(text)
        text.gsub(/<(filter|macro|typo):([_a-zA-z0-9]+)([^>]*)\/>/) do
          self.for($2.to_sym).process(nil, parse_arguments($3))
        end.gsub(/<(filter|macro|typo):([_a-zA-z0-9]+)([^>]*)>(.*?)<\/\1:\2>/) do
          self.for($2.to_sym).process($4, parse_arguments($3))
        end
      end

      # :nodoc: Parse a filter arugment string.
      def parse_arguments(arg_string)
        unparsed = arg_string.strip
        pattern = /\A([_a-zA-z0-9]+)\s*=\s*("([^"]*)"|'([^']*)')\s*(.*)\z/m
        args = {}
        until unparsed == ''
          m = unparsed.match(pattern)
          m or raise "Can't parse filter arguments: <#{arg_string}>"
          args[m[1].to_sym] = m[3] || m[4]
          unparsed = m[5]
        end
        args
      end
    end
  end
end
