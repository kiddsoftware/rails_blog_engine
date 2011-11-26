module RailsBlogEngine
  module Ability
    def can_read_blog
      can :read, RailsBlogEngine::Post
      can [:read, :create], RailsBlogEngine::Comment
    end

    def can_manage_blog
      alias_action :mark_as_spam, :to => :update
      alias_action :mark_as_ham, :to => :update

      can :manage, RailsBlogEngine::Post
      can :update, RailsBlogEngine::Comment
    end
  end
end
