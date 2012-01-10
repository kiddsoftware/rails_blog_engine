module RailsBlogEngine
  class Ability
    include CanCan::Ability

    def initialize(user)
      can_read_blog
      if user && blog_admin?(user)
        can_manage_blog
      end
    end

    protected

    def blog_admin?(user)
      method = Rails.configuration.rails_blog_engine.blog_admin_method
      if user.respond_to?(method)
        user.send(method)
      else
        raise "You must define #{method} on your user model, as described in README.md"
      end
    end

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
