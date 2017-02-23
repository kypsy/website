class WelcomeController < ApplicationController
  skip_before_action :restrict_non_visible_user

  def index
    if logged_in?
      @title = "People Using Kypsy"
      @users = current_user.viewable_users.order('created_at desc').paginate(page: params[:page] ||= 1)
      @crushers         = current_user.crushers
      @crushes          = current_user.crushes
      @bookmarked_users = current_user.bookmarked_users
      @avatar_size      = :square
      @slug     = "people"
      return render("/welcome/dashboard")
    end

    @slug  = "welcome"
    @users = User.visible.featured.shuffle.first(12)
  end
end
