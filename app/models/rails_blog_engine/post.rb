module RailsBlogEngine
  class Post < ActiveRecord::Base
    belongs_to :author, :polymorphic => true

    validates :title, :presence => true
    validates :body, :presence => true
    validates(:state, :presence => true,
              :inclusion => { :in => %w(unpublished published) })
    validates :permalink, :presence => true, :uniqueness => true
    validates :author, :presence => true

    attr_accessible :title, :body, :permalink, :author

    # We use a state machine to represent our publication state.  This is
    # mostly because I visualize a UI with a great big "Publish" button,
    # and not a "Published" checkbox in a form.
    #
    # If you'd like to upgrade your blog into a content-management system
    # with some kind of pre-publication review, just adjust the states and
    # transitions.
    state_machine :state, :initial => :unpublished do
      state :unpublished
      state :published

      event :publish do
        transition any => :published
      end

      event :unpublish do
        transition any => :unpublished
      end
    end
  end
end
