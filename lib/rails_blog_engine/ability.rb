module RailsBlogEngine
  module Ability
    def can_read_blog
      can :read, RailsBlogEngine::Post
    end
  end
end
