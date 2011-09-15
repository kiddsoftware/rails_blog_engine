# -*- coding: utf-8 -*-
require 'spec_helper'

describe RailsBlogEngine::PostsController do
  include Devise::TestHelpers

  render_views

  describe "GET '/blog/posts.atom'" do
    let!(:post) do
      RailsBlogEngine::Post.make!(:published,
                                  :title => "Title",
                                  :body => "Body",
                                  :permalink => "permalink")
    end

    before do
      get :index, :format => 'atom', :use_route => :rails_blog_engine
      response.should be_success
    end

    it "has an ATOM MIME type" do
      response.content_type.should == 'application/atom+xml'
    end

    it "has a UTF-8 encoding" do
      response.body.should match(/encoding="UTF-8"/)
    end

    it "returns an atom feed" do
      puts response.body
      response.body.should have_selector('feed')
      response.body.should have_selector('link[@rel="alternate"][@type="text/html"][@href="http://test.host/blog/"]')
    end
  end
end
