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
    VCR.use_cassette('rakismet-ham') { post_ham_comment }
    last_comment.should be_filtered_as_ham
    page.should have_content(last_comment.body)
    page.should_not have_content("moderation")
  end

  scenario 'Posting a spam comment' do
    enable_spam_filter
    VCR.use_cassette('rakismet-spam') { post_spam_comment }
    last_comment.should be_filtered_as_spam
    page.should_not have_content(last_comment.body)
    page.should have_content("moderation")
  end

  scenario 'Posting a comment without configuring the spam filter' do
    disable_spam_filter
    post_spam_comment
    last_comment.should be_unfiltered
  end

  # Wait for the comment to have the specified state.  This forces us to
  # synchronize the current thread with the background thread the runs the
  # webserver, which is helpful for ensuring that VCR cassettes will be
  # left "in the VCR" until they've actually been used by the other thread.
  def wait_for_comment_in_state(state)
    Timeout.timeout(3) do
      sleep 0.1 until RailsBlogEngine::Comment.where(:state => state.to_s).first
    end
  end

  scenario 'Filtered as ham, mark as spam', :js => true do
    enable_spam_filter
    VCR.use_cassette('rakismet-ham', :match_requests_on => [:method]) do
      post_spam_comment
      wait_for_comment_in_state(:filtered_as_ham)
    end
    page.should have_content('viagra-test-123')
    page.should have_selector('.filtered_as_ham')

    sign_in_as_admin
    VCR.use_cassette('rakismet-train-as-spam') do
      click_on 'Spam'
      wait_for_comment_in_state(:marked_as_spam)
    end
    page.should have_content('viagra-test-123')
    page.should have_selector('.marked_as_spam')
  end

  scenario 'Filtered as spam, mark as ham', :js => true do
    enable_spam_filter
    VCR.use_cassette('rakismet-spam', :match_requests_on => [:method]) do
      post_ham_comment
      wait_for_comment_in_state(:filtered_as_spam)
    end
    page.should_not have_content('Jane Doe')

    sign_in_as_admin
    page.should have_content('Jane Doe')
    page.should have_selector('.filtered_as_spam')

    VCR.use_cassette('rakismet-train-as-ham') do
      click_on 'Not Spam'
      wait_for_comment_in_state(:marked_as_ham)
    end
    page.should have_content('Jane Doe')
    page.should have_selector('.marked_as_ham')
  end
end
