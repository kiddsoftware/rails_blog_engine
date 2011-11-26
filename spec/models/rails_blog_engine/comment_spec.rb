require 'spec_helper'

describe RailsBlogEngine::Comment do
  it { should belong_to(:post) }

  it { should_not allow_value('').for(:author_byline) }
  it { should_not allow_value('').for(:body) }

  describe ".visible" do
    it "includes unfiltered and ham messages, but not spam" do
      @unfiltered = RailsBlogEngine::Comment.make!
      @ham = RailsBlogEngine::Comment.make!(:state => 'filtered_as_ham')
      @spam = RailsBlogEngine::Comment.make!(:state => 'filtered_as_spam')
      RailsBlogEngine::Comment.visible.should include(@unfiltered)
      RailsBlogEngine::Comment.visible.should include(@ham)
      RailsBlogEngine::Comment.visible.should_not include(@spam)
    end
  end

  describe "#state" do
    subject { RailsBlogEngine::Comment.make! }

    it "begins in state unfiltered" do
      subject.should be_unfiltered
    end

    it "transitions to filtered_as_ham if rakismet likes it" do
      Rakismet.key = "fakekey"
      subject.stub(:spam?) { false }
      subject.run_spam_filter
      subject.should be_filtered_as_ham
    end

    it "transitions to filtered_as_spam if rakismet doesn't like it" do
      Rakismet.key = "fakekey"
      subject.stub(:spam?) { true }
      subject.run_spam_filter
      subject.should be_filtered_as_spam
    end

    it "remains unfiltered if the rakismet is not configured" do
      Rakismet.key = nil
      subject.run_spam_filter
      subject.should be_unfiltered
    end
  end
end
