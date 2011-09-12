require 'acceptance/acceptance_helper'

feature 'Posts', %q{
  In order to learn intesting new things
  As a site visitor
  I want to read blog articles
} do

  background do
    RailsBlogEngine::Post.make!(:title => "Test Post", :body => "Body")
  end

  scenario 'Viewing the index' do
    visit '/blog'
    page.should have_content("Test Post")
    page.should have_content("Body")
  end
end
