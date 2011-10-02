# -*- coding: utf-8 -*-
require 'spec_helper'

describe RailsBlogEngine::PostsController do
  include Devise::TestHelpers

  render_views

  describe "GET '/blog/posts.atom'" do
    before do
      base = 1.day.ago
      @posts = (0...20).map do |i|
        RailsBlogEngine::Post.make!(:published,
                                    published_at: base + i.seconds,
                                    title: "Title #{i}",
                                    body: "Body #{i}",
                                    permalink: "permalink-#{i}")
      end
      @updated_post = @posts[15]
      @updated_post.updated_at = Time.now
      @updated_post.save!
      @unpublished = RailsBlogEngine::Post.make!(title: "Unpublished")
    end

    before do
      get :index, format: 'atom', use_route: :rails_blog_engine
      response.should be_success
    end

    it "has an ATOM MIME type" do
      response.content_type.should == 'application/atom+xml'
    end

    it "has a UTF-8 encoding" do
      response.body.should match(/encoding="UTF-8"/)
    end

    it "returns an ATOM feed header" do
      puts response.body
      response.body.should have_selector('feed')
      response.body.should have_selector('link[@rel="alternate"][@type="text/html"][@href="http://test.host/blog/"]')
      expected_title = I18n.t('rails_blog_engine.blog.title')
      response.body.should have_selector('title', :text => expected_title)
    end

    it "reports when the feed was last updated" do
      last_update = @updated_post.updated_at.iso8601
      response.body.should have_selector('updated', :text => last_update)
    end

    it "includes recent, published posts in the ATOM feed" do
      response.body.should have_selector('entry title', :text => "Title 19")
      response.body.should_not have_selector('entry title', :text => "Title 3")
      response.body.should_not have_selector('entry title',
                                             :text => "Unpublished")
    end
  end
end
