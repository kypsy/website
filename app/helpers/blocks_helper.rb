module BlocksHelper
  def blocked?(user)
    current_user.blocks.where(blocked_id: user.id).any?
  end
end
