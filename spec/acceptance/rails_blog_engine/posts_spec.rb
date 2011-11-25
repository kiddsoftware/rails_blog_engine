require 'acceptance/acceptance_helper'

feature 'Posts', %q{
  In order to learn intesting new things
  As a site visitor
  I want to read blog articles
} do

  background do
    published_at = Time.utc(2011, 01, 02, 03)
    RailsBlogEngine::Post.make!(:title => "Test Post", :body => "_Body_ ",
                                :state => 'published',
                                :published_at => published_at,
                                :permalink => 'test')
  end

  scenario 'Viewing the index' do
    visit '/blog'
    page.should have_content("Test Post")
    within('em') { page.should have_content("Body") }
    page.should_not have_content("New Post")
  end

  scenario 'Navigating to a post' do
    visit '/blog'
    click_on "Test Post"
    page.should have_content("Test Post")
    page.should_not have_content("New Post")
    within('em') { page.should have_content("Body") }
    page.should_not have_content("Edit Post")
  end

  scenario 'Linking to a post directly' do
    visit '/blog/2011/01/02/test'
    page.should have_content("Test Post")
  end

  scenario 'Looking for posts on page 2' do
    # Force our original post off the front page.
    5.times { RailsBlogEngine::Post.make!(:published) }

    visit '/blog'
    page.should_not have_content("Test Post")
    click_on "Next"
    page.should have_content("Test Post")
    current_path.should == '/blog/page/2'
  end
end
