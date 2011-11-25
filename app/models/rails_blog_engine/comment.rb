module RailsBlogEngine
  class Comment < ActiveRecord::Base
    # Define the functions spam?, spam!, and ham!.
    include Rakismet::Model

    belongs_to :post, :class_name => 'RailsBlogEngine::Post'

    validates :author_byline, :presence => true
    validates :body, :presence => true

    # Tell rakismet where to find the fields it needs for the spam filter.
    # We don't need to specify fields which already have the right name.
    #
    # TODO: Include article permalink.
    rakismet_attrs(:author => :author_byline, :content => :body,
                   :user_ip => :author_ip, :user_agent => :author_user_agent)
  end
end
