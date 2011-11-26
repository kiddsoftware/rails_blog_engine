require 'acceptance/acceptance_helper'

feature 'Spam filtering', %q{
  In order to keep my site free of spam
  As a manager of the blog
  I want to identify spam posts and hide them automatically
} do

  background do
    @post = RailsBlogEngine::Post.make!(:published, :title => "Example post")
    visit '/blog'
    click_on "Example post"
  end

  def enable_spam_filter
    Rakismet.key = "fakekey"
    Rakismet.url = "http://www.example.com/"
  end

  def disable_spam_filter
    Rakismet.key = nil
    Rakismet.url = nil
  end

  def post_ham_comment
    fill_in "Your name", :with => "Jane Doe"
    fill_in "Comment", :with => "An interesting and legitimate post."
    click_on "Post Comment"
  end

  def post_spam_comment
    fill_in "Your name", :with => "viagra-test-123"
    fill_in "Comment", :with => "Buy toner cartridges today!"
    click_on "Post Comment"
  end

  def last_comment
    @last_comment ||= RailsBlogEngine::Comment.last
  end

  scenario 'Posting a real comment' do
    enable_spam_filter
    VCR.use_cassette('rakismet-ham') do
      post_ham_comment
      last_comment.should be_filtered_as_ham
      page.should have_content(last_comment.body)
      page.should_not have_content("moderation")
    end
  end

  scenario 'Posting a spam comment' do
    enable_spam_filter
    VCR.use_cassette('rakismet-spam') do
      post_spam_comment
      last_comment.should be_filtered_as_spam
      page.should_not have_content(last_comment.body)
      page.should have_content("moderation")
    end
  end

  scenario 'Posting a comment without configuring the spam filter' do
    disable_spam_filter
    post_spam_comment
    last_comment.should be_unfiltered
  end
end
