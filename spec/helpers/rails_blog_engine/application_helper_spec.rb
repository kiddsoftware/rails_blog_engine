require 'spec_helper'

describe RailsBlogEngine::ApplicationHelper do
  describe ".markdown" do
    it "converts markdown text to HTML" do
      helper.markdown("_foo_ bar").should match(/<em>foo<\/em> bar/)
    end

    it "does not pass scripts" do
      helper.markdown("<script>foo</script>").should_not match(/foo/)
    end
  end
end
