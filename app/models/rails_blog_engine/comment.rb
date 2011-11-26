module RailsBlogEngine
  class Comment < ActiveRecord::Base
    # Define the functions spam?, spam!, and ham!.
    include Rakismet::Model

    belongs_to :post, :class_name => 'RailsBlogEngine::Post'

    validates :author_byline, :presence => true
    validates :body, :presence => true

    # Comments that are visible to the public.
    scope :visible, where(:state => ['unfiltered', 'filtered_as_ham'])

    # Tell rakismet where to find the fields it needs for the spam filter.
    # We don't need to specify fields which already have the right name.
    #
    # TODO: Include article permalink.
    rakismet_attrs(:author => :author_byline, :content => :body,
                   :user_ip => :author_ip, :user_agent => :author_user_agent)

    # A state machine which keeps track of our spam filter status.
    state_machine :state, :initial => :unfiltered do
      state :unfiltered
      state :filtered_as_ham
      state :filtered_as_spam

      event :filter_as_ham do
        transition :unfiltered => :filtered_as_ham
      end

      event :filter_as_spam do
        transition :unfiltered => :filtered_as_spam
      end
    end

    # Run the spam filter on this comment and update it appropriately.
    def run_spam_filter
      return unless Rakismet.key
      if spam?
        filter_as_spam!
      else
        filter_as_ham!
      end
    end
  end
end
