class WelcomeController < ApplicationController
  skip_before_action :restrict_non_visible_user

  def index
    if logged_in?
      @title            = "People Using #{t(:brand)}"
      @users            = current_user.viewable_users.order('created_at desc').paginate(page: params[:page] ||= 1)
      @crushers         = current_user.crushers
      @crushes          = current_user.crushes - current_user.matches
      @bookmarked_users = current_user.bookmarked_users
      @matches          = current_user.matches
      @avatar_size      = :square
      @slug             = "people"
      return render "/welcome/dashboard", layout: "application"
    else
      @slug  = "welcome"
      return render layout: "welcome"
    end
  end
end
