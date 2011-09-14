require 'spec_helper'

describe RailsBlogEngine::Filters::Code do
  let(:filter) { RailsBlogEngine::Filters::Code.new }

  describe ".process" do
    it "applies syntax highlighting to code blocks" do
      output = filter.process(<<END_OF_CODE, :lang => 'ruby')
def foo
  42
end
END_OF_CODE
      output.should match(/foo/)
    end
  end
end
