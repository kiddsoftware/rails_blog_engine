require 'acceptance/acceptance_helper'

feature 'Posts admin', %q{
  In order to publish information to the world
  As a manager of the blog
  I want to publish and manage posts
} do

  background do
    visit '/users/sign_up'
    fill_in 'Email', :with => "sue@example.com"
    fill_in 'Password', :with => "password"
    fill_in 'Password confirmation', :with => "password"
    click_button 'Sign up'
  end

  scenario 'Adding and editing new post', :js => true do
    visit '/blog'

    click_link "New Post"
    fill_in 'Title', :with => 'Test Post'
    fill_in 'Permalink', :with => 'test-post'
    fill_in 'Body', :with => 'My post'
    click_button 'Create Post'
    page.should have_content("Test Post")
    page.should have_content("by sue")
    page.should have_content("My post")

    click_link "Edit"
    fill_in 'Title', :with => 'New Title'
    fill_in 'Body', :with => 'New Body'
    click_button "Update Post"
    page.should have_content('New Title')
    page.should have_content('New Body')
  end
end
