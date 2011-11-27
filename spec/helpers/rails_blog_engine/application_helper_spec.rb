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
      helper.markdown("<script>foo</script>").
        should_not match(/script/)
    end

    it "applies filters" do
      helper.markdown("<filter:silly/>").should match(/Whee/)
    end

    context "for trusted users" do
      it "allows images" do
        helper.markdown("<img src='foo.png'>", :trusted => true).
          should match(/<img/)
      end

      it "does not add nofollow to links" do
        helper.markdown("<a href='foo.html'>", :trusted => true).
          should_not match(/nofollow/)
      end

      it "allows code highlighting" do
        formatted = helper.markdown(<<EOD, :trusted => true)
<div class='foo'><span class='bar'></span></div>
EOD
        formatted.should match(/foo/)
        formatted.should match(/bar/)
      end
    end

    context "for untrusted users" do
      it "does not allow images" do
        helper.markdown("<img src='foo.png'>").should_not match(/<img/)
      end

      it "adds nofollow to links" do
        helper.markdown("<a href='foo.html'>").should match(/nofollow/)
      end
    end
  end
end
