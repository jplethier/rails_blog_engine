class Ability
  include CanCan::Ability
  include RailsBlogEngine::Ability

  def initialize(user)
    can_read_blog
    if user
      can_manage_blog
    end
  end
end
