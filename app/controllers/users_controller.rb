class UsersController < ApplicationController
  skip_before_action :restrict_non_visible_user, only: [:new, :create]
  before_action      :require_login
  before_action      :search_term,               only: :index

  def index
    @title       = t("titles.users", brand: t(:brand))
    @slug        = "people"
    @avatar_size = :medium

    @users = if logged_in?
      current_user.viewable_users.search(@search)
    else
      User.visible
    end

    @total = @users.length
    @users = @users.listing_order.paginate(page: params[:page] ||= 1)

    # if @total.zero?
    #   flash[:notice] = t("search.no_results")
    #   return redirect_to people_search_path
    # end
  end

  def show
    @slug  = "person"

    find_user_by_username

    if @user
      @title = t("titles.profile", username: @user.username, brand: t(:brand))
      @crush = Crush.new
    else
      redirect_to root_path, notice: t("user.nonexistent_user")
    end
  end

  def new
    @slug  = "settings"
    @title = t("titles.getting_started", brand: t(:brand))
    @user  = current_user

    if @user.nil? or @user.visible?
      return redirect_to(root_path)
    else
      begin
        @facebook = Social::Facebook.new(@user)
      rescue Social::SocialError
      end
    end
  end

  def create
    @user = current_user

    if @user.update(params.require(:user).permit(:username, :email, :agreed_to_terms_at))
      @user.visiblize!
      # redirect_to new_photo_path(getting: "started")
      redirect_to settings_path
    else
      render :new
    end
  end

  def edit
    @interest = Interest.new
    @activity = Activity.new
    @title = t("titles.settings", brand: t(:brand))
    @slug  = "settings"
    @user  = current_user
    @label_assignements = @user.your_labels.label_assignments
  end

  def update
    # "other" Interest
    if params[:interest][:name].present?
      @interest = Interest.create(name: params[:interest][:name])

      if @interest.present?
        current_user.interests << @interest
      end
    end

    # "other" Activity
    if params[:activity][:name].present?
      @activity = Activity.create(name: params[:activity][:name])

      if @activity.present?
        current_user.activities << @activity
      end
    end

    # save settings
    if current_user.update(user_params)
      redirect_to(person_path(current_user.username), notice: t("user.settings_updated"))
    else
      @label_assignements = current_user.your_labels.label_assignments
      render action: "edit"
    end
  end

  def delete_account
    @title = t("titles.delete_account")
    @slug  = "settings"
    @user  = current_user
  end

  def blocked
    @title = t("titles.blocked_users")
    @slug  = "settings"
    @user  = current_user
  end

  def destroy
    @user = current_user
    @user.photos.destroy_all
    @user.destroy
    cookies.delete :kypsy_auth_token
    redirect_to root_path, notice: t("users.deleted")
  end

  private

  def search_term
    return unless params[:search]
    search = params[:search].split("/", 2)

    @search, @query, @column = if search.count.even?
      [Hash[*search], search.last, search.first]
    else
      [search.first, search.first, nil]
    end

    if User::DISALLOWED_COLUMNS.include? @column.try(:to_sym)
      @search, @column = [@query, nil]
      params[:search] = @search
    end
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :website,
      :email_crushes,
      :email_messages,
      :location,
      :bio,
      :age_range_id,

      :facebook_username,
      :instagram_username,
      :kik_username,
      :lastfm_username,
      :snapchat_username,
      :spotify_username,
      :tumblr_username,
      :twitter_username,
      :label_id,
      :alcohol,
      :cigarettes,
      :marijuana,
      your_labels_attributes: [:label_id, :id, :_destroy, :label_type]
    )
  end
end
