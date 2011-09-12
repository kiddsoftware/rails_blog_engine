class CreateRailsBlogEnginePosts < ActiveRecord::Migration
  def change
    create_table :rails_blog_engine_posts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
