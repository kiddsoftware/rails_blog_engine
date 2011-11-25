require 'spec_helper'

describe RailsBlogEngine::Comment do
  it { should belong_to(:post) }

  it { should_not allow_value('').for(:author_byline) }
  it { should_not allow_value('').for(:body) }
end
