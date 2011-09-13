module RailsBlogEngine
  module Ability
    def can_read_blog
      can :read, RailsBlogEngine::Post
    end

    def can_manage_blog
      can :manage, RailsBlogEngine::Post
    end
  end
end
