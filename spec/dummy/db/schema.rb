# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111125111958) do

  create_table "rails_blog_engine_comments", :force => true do |t|
    t.integer  "post_id"
    t.string   "author_byline"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.string   "author_user_agent"
    t.boolean  "author_can_post"
    t.string   "referrer"
    t.string   "state"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_blog_engine_comments", ["author_email"], :name => "index_rails_blog_engine_comments_on_author_email"
  add_index "rails_blog_engine_comments", ["post_id"], :name => "index_rails_blog_engine_comments_on_post_id"

  create_table "rails_blog_engine_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.datetime "published_at"
    t.string   "permalink"
    t.integer  "author_id"
    t.string   "author_type"
    t.string   "author_byline"
  end

  add_index "rails_blog_engine_posts", ["permalink"], :name => "index_rails_blog_engine_posts_on_permalink"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
