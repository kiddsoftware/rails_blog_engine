require 'spec_helper'

describe RailsBlogEngine::Post do
  it { should allow_value("Title").for(:title) }
  it { should_not allow_value("").for(:title) }

  it { should allow_value("Body").for(:body) }
  it { should_not allow_value("").for(:body) }
end
