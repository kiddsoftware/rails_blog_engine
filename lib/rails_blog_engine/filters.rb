require 'rails_blog_engine/filters/base'

module RailsBlogEngine::Filters

  # :nodoc: All registered filters.
  FILTERS = {}

  # Register a filter class to be used by #apply_all_to.
  def self.register_filter(name, filter_class)
    FILTERS[name] = filter_class.new
  end

  # Look up a registered filter class.  Raises an error if the filter
  # can't be found.
  def self.find(name)
    FILTERS[name] or raise "Text filter not installed: #{name}"
  end

  # Apply all registered filters to the specified text.
  def self.apply_all_to(text)
    text.gsub(/<(filter|macro|typo):([_a-zA-z0-9]+)([^>]*)\/>/) do
      trap_filter_errors do
        find($2.to_sym).process(nil, parse_arguments($3))
      end
    end.gsub(/<(filter|macro|typo):([_a-zA-z0-9]+)([^>]*)>(.*?)<\/\1:\2>/) do
      trap_filter_errors do
        find($2.to_sym).process($4, parse_arguments($3))
      end
    end
  end

  protected

  # :nodoc: Trap a filter's errors and return an error message.
  def self.trap_filter_errors
    yield rescue "<p><strong>#{$!.to_s}</strong></p>"
  end

  # :nodoc: Parse a filter arugment string.
  def self.parse_arguments(arg_string)
    unparsed = arg_string.strip
    pattern = /\A([_a-zA-z0-9]+)\s*=\s*("([^"]*)"|'([^']*)')\s*(.*)\z/m
    args = {}
    until unparsed == ''
      m = unparsed.match(pattern)
      m or raise "Can't parse filter arguments: {{#{arg_string}}}"
      args[m[1].to_sym] = m[3] || m[4]
      unparsed = m[5]
    end
    args
  end
end
