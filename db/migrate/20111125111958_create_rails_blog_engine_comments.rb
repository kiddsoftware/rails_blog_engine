class CreateRailsBlogEngineComments < ActiveRecord::Migration
  def change
    create_table :rails_blog_engine_comments do |t|
      t.references :post
      t.string :author_byline
      t.string :author_email
      t.string :author_url
      t.string :author_ip
      t.string :author_user_agent
      t.boolean :author_can_post
      t.string :referrer
      t.string :state
      t.text :body

      t.timestamps
    end

    add_index :rails_blog_engine_comments, :post_id
    add_index :rails_blog_engine_comments, :author_email
  end
end
