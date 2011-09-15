require 'spec_helper'

describe RailsBlogEngine::Filters do

  # A sample filter.
  class HelloFilter < RailsBlogEngine::Filters::Base
    register_filter :hello

    def process(text, options)
      attrs =
        if options[:class] then " class=\"#{options[:class]}\"" else "" end
      name = if text then ", #{text}" else "" end
      "<p#{attrs}>Hello#{name}!</p>"
    end
  end

  describe ".find" do
    it "returns the filter registered for a name" do
      RailsBlogEngine::Filters.find(:hello).should be_kind_of(HelloFilter)
    end
  end

  describe ".apply_all_to" do
    %w(filter macro typo).each do |tag|
      it "applies registered filters to empty '#{tag}' tags" do
        RailsBlogEngine::Filters.apply_all_to(<<"END_OF_INPUT").should == <<END_OF_OUTPUT
<#{tag}:hello/>
<#{tag}:hello class="example" />
END_OF_INPUT
<p>Hello!</p>
<p class="example">Hello!</p>
END_OF_OUTPUT
      end

      it "applies registered filters to '#{tag}' tags with content" do
        RailsBlogEngine::Filters.apply_all_to(<<"END_OF_INPUT").should == <<END_OF_OUTPUT
<#{tag}:hello>Judy</#{tag}:hello>
<#{tag}:hello class='example' extra="" >Mike
Smith</#{tag}:hello>
END_OF_INPUT
<p>Hello, Judy!</p>
<p class="example">Hello, Mike
Smith!</p>
END_OF_OUTPUT
      end
    end

    it "reports errors inline" do
        RailsBlogEngine::Filters.apply_all_to(<<END_OF_INPUT).should == <<END_OF_OUTPUT
<filter:invalid/>
<filter:hello class= >Mike</filter:hello>
END_OF_INPUT
<p><strong>Text filter not installed: invalid</strong></p>
<p><strong>Can't parse filter arguments: {{ class= }}</strong></p>
END_OF_OUTPUT
    end
  end
end
