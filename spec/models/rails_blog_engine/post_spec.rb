require 'spec_helper'

describe RailsBlogEngine::Post do
  include RailsBlogEngine

  describe "validations" do
    before { Post.make! }

    it { should allow_value("Title").for(:title) }
    it { should_not allow_value("").for(:title) }

    it { should allow_value("Body").for(:body) }
    it { should_not allow_value("").for(:body) }

    %w(unpublished published).each do |state|
      it { should allow_value(state).for(:state) }
    end
    it { should_not allow_value("invalid").for(:state) }
    it { should validate_presence_of(:state) }

    it { should allow_value("abc-def").for(:permalink) }
    it { should validate_presence_of(:permalink) }
    it { should validate_uniqueness_of(:permalink) }

    it { should validate_presence_of(:author) }
  end

  describe "state machine" do
    let(:post) { Post.make }

    it "begins as unpublished" do
      post.should be_unpublished
    end

    it "can be published and unpublished" do
      2.times { post.publish!; post.should be_published }
      2.times { post.unpublish!; post.should be_unpublished }
    end
  end
end
