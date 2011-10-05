require 'spec_helper'

describe RailsBlogEngine::Post do
  Post = RailsBlogEngine::Post

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

  describe ".recently_published" do
    before do
      base = Time.now
      @posts = (0...3).map do |i|
        Post.make!(:published, :published_at => base + i.seconds)
      end
      @posts[1].published_at = base + 10.seconds
      @posts[1].save!
      @unpublished = Post.make!
    end

    it "does not include unpublished posts" do
      Post.recently_published.should_not include(@unpublished)
    end

    it "returns in order of descending published_at" do
      Post.recently_published.should == [@posts[1], @posts[2], @posts[0]]
    end

    it "excludes posts which have been explicitly unpublished" do
      @posts[1].unpublish!
      Post.recently_published.should == [@posts[2], @posts[0]]
    end
  end

  describe "state machine" do
    let(:post) { Post.make }

    it "begins as unpublished" do
      post.should be_unpublished
    end

    it "can be published and unpublished" do
      post.publish!
      post.should be_published

      lambda do
        post.publish!
      end.should raise_error(StateMachine::InvalidTransition)

      post.unpublish!
      post.should be_unpublished

      lambda do
        post.unpublish!
      end.should raise_error(StateMachine::InvalidTransition)
    end
  end

  describe "published_at" do
    it "is set automatically when post is first published" do
      first_publication = Time.utc(1980, 1, 1)
      second_publication = Time.utc(1980, 1, 2)

      post = Post.make
      post.published_at.should be_nil

      Time.stub(:now) { first_publication }
      post.publish
      post.published_at.should == first_publication

      Time.stub(:now) { second_publication }
      post.publish
      post.published_at.should == first_publication
    end
  end

  describe "#author_byline" do
    it "is set from the #author method before save" do
      author = User.make(:email => 'jane@example.com')
      Post.make!(:author => author).author_byline.
        should == 'jane'
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
