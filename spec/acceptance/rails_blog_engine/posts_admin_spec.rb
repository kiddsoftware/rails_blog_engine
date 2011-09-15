require 'acceptance/acceptance_helper'

feature 'Posts admin', %q{
  In order to publish information to the world
  As a manager of the blog
  I want to publish and manage posts
} do

  background do
    @user = User.make!(:email => 'sue@example.com')
    visit '/users/sign_in'
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button 'Sign in'
  end

  scenario 'Adding a new post' do
    visit '/blog/posts/new'
    fill_in 'Title', :with => 'Test Post'
    fill_in 'Permalink', :with => 'test-post'
    fill_in 'Body', :with => 'My post'
    click_button 'Create Post'
    page.should have_content("Test Post")
    page.should have_content("by sue")
    page.should have_content("My post")
  end

  scenario 'Editing a post' do
    post = RailsBlogEngine::Post.make!(:published)
    visit "/blog/posts/#{post.to_param}/edit"
    fill_in 'Title', :with => 'New Title'
    fill_in 'Body', :with => 'New Body'
    click_button "Update Post"
    page.should have_content('New Title')
    page.should have_content('New Body')
  end
end
