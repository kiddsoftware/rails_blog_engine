require 'spec_helper'

describe RailsBlogEngine::Filters::Base do
  include RailsBlogEngine

  describe "#process" do
    it "raises an error if not overridden" do
      lambda do
        Filters::Base.new.process("text", {})
      end.should raise_error(/override/)
    end
  end
end
