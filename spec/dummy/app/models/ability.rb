class Ability
  include CanCan::Ability
  include RailsBlogEngine::Ability

  def initialize(user)
    can_read_blog
  end
end
