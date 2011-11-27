require 'acceptance/acceptance_helper'

feature 'Posts admin', %q{
  In order to publish information to the world
  As a manager of the blog
  I want to publish and manage posts
} do

  background do
    sign_in_as_admin
  end

  scenario 'Adding and editing new post', :js => true do
    visit '/blog'

    click_link "New Post"
    fill_in 'Title', :with => 'Test Post'
    fill_in 'Permalink', :with => 'test-post'
    fill_in 'Body', :with => 'My post <img src="a.png">'
    click_button 'Create Post'
    page.should have_content("Test Post")
    page.should have_content("by sue")
    page.should have_content("My post")
    page.should have_selector(:xpath, '//img[@src="a.png"]')

    click_link "Edit"
    fill_in 'Title', :with => 'New Title'
    fill_in 'Body', :with => 'New Body'
    click_button "Update Post"
    page.should have_content('New Title')
    page.should have_content('New Body')
  end
end
