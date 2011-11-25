require 'acceptance/acceptance_helper'

feature 'Spam filtering', %q{
  In order to keep my site free of spam
  As a manager of the blog
  I want to identify spam posts and hide them automatically
} do

  background do
    Rakismet.key = "fakekey"
    Rakismet.url = "http://www.example.com/"

    @post = RailsBlogEngine::Post.make!(:published, :title => "Example post")
    visit '/blog'
    click_on "Example post"
  end

  scenario 'Posting a real comment' do
    VCR.use_cassette('rakismet-ham') do
      fill_in "Your name", :with => "Jane Doe"
      fill_in "Comment", :with => "An interesting and legitimate post."
      click_on "Post Comment"

      c = RailsBlogEngine::Comment.where(:author_byline => "Jane Doe").first
      c.should_not be_spam
    end
  end

  scenario 'Posting a spam comment' do
    VCR.use_cassette('rakismet-spam') do
      fill_in "Your name", :with => "viagra-test-123"
      fill_in "Comment", :with => "Buy toner cartridges today!"
      click_on "Post Comment"

      c = RailsBlogEngine::Comment.
        where(:author_byline => "viagra-test-123").first
      c.should be_spam
    end
  end
end
