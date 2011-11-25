# -*- coding: utf-8 -*-
require 'spec_helper'

describe RailsBlogEngine::PostsController do
  include Devise::TestHelpers

  render_views

  describe "GET '/blog/posts.atom'" do
    before do
      base = Time.utc(2011, 01, 02)
      @user = User.make!(:email => 'jdoe@example.com')
      @posts = (0...20).map do |i|
        RailsBlogEngine::Post.make!(:published,
                                    :published_at => base + i.seconds,
                                    :title => "Title #{i}",
                                    :body => "Body #{i}",
                                    :permalink => "permalink-#{i}",
                                    :author => @user)
      end
      @updated_post = @posts[15]
      @updated_post.updated_at = Time.now
      @updated_post.save!
      @unpublished = RailsBlogEngine::Post.make!(:title => "Unpublished")
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

    it "returns an ATOM feed header" do
      puts response.body
      response.body.should have_selector('feed')
      response.body.should have_selector('link[@rel="alternate"][@type="text/html"][@href="http://test.host/blog/"]')
      response.body.should have_selector('link[@rel="self"][@type="application/atom+xml"][@href="http://test.host/blog/posts.atom"]')
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

    context "each entry" do
      it "includes publication times, not creation times" do
        published_at = @posts.last.published_at.iso8601
        response.body.should have_selector('entry published',
                                  :text => published_at)
      end

      it "includes author information" do
        response.body.should have_selector('entry author name', :text => "jdoe")
      end

      it "links to the post by permalink" do
        response.body.should have_selector('entry link[@rel="alternate"][@type="text/html"][@href="http://test.host/blog/2011/01/02/permalink-19"]')
      end

      it "includes the formatted body text" do
        response.body.should have_selector('entry content', :content => "Body")
      end
    end
  end
end
