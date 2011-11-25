module RailsBlogEngine
  class Comment < ActiveRecord::Base
    belongs_to :post, :class_name => 'RailsBlogEngine::Post'

    validates :author_byline, :presence => true
    validates :body, :presence => true
  end
end
