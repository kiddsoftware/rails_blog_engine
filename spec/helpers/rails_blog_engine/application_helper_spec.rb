require 'spec_helper'

describe RailsBlogEngine::ApplicationHelper do
  class SillyFilter < RailsBlogEngine::Filters::Base
    register_filter :silly

    def process(text, options)
      "Whee"
    end
  end

  describe ".markdown" do
    it "converts markdown text to HTML" do
      helper.markdown("_foo_ bar").should match(/<em>foo<\/em> bar/)
    end

    it "does not pass scripts" do
      helper.markdown("<script>foo</script>").should_not match(/foo/)
    end

    it "applies filters" do
      helper.markdown("<filter:silly/>").should match(/Whee/)
    end
  end
end
