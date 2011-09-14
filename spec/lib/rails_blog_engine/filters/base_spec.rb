require 'spec_helper'

describe RailsBlogEngine::Filters::Base do
  let(:filter) { RailsBlogEngine::Filters::Base.new }

  describe "#process" do
    it "raises an error if not overridden" do
      lambda do
        filter.process("text", {})
      end.should raise_error(/override/)
    end
  end
end
