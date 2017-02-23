module BlocksHelper
  def blocked?
    current_user.blocks.where(blocked_id: @user.id).any?
  end
end
