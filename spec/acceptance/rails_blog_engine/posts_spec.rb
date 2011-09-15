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

  scenario 'Viewing a post' do
    visit '/blog/2011/01/02/test'
    page.should have_content("Test Post")
    page.should_not have_content("New Post")
    within('em') { page.should have_content("Body") }
    page.should_not have_content("Edit Post")
  end
end
