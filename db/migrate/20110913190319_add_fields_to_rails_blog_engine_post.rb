class AddFieldsToRailsBlogEnginePost < ActiveRecord::Migration
  def change
    add_column :rails_blog_engine_posts, :state, :string
    add_column :rails_blog_engine_posts, :published_at, :datetime
    add_column :rails_blog_engine_posts, :permalink, :string
    add_column :rails_blog_engine_posts, :author_id, :integer
    add_column :rails_blog_engine_posts, :author_type, :string
    add_column :rails_blog_engine_posts, :author_byline, :string

    add_index :rails_blog_engine_posts, :permalink
  end
end
