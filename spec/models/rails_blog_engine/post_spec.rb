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

  describe "#author_byline" do
    it "is set from the #author method before save" do
      author = User.make(:email => 'jane@example.com')
      Post.make!(:author => author).author_byline.should == 'jane'
    end
  end

  describe ".author_byline" do
    it "returns .byline if present" do
      author = mock('author', :byline => 'Jane Smith')
      Post.author_byline(author).should == 'Jane Smith'
    end

    it "returns .email without domain if present" do
      author = mock('author', :email => 'jane@example.com')
      Post.author_byline(author).should == 'jane'
    end

    it "returns 'unknown' otherwise" do
      author = mock('author')
      Post.author_byline(author).should == 'unknown'
    end
  end
end
