class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV["STAGING_USERNAME"], password: ENV["STAGING_PASSWORD"] if Rails.env.staging?

  protect_from_forgery with: :exception

  before_action :enforce_proper_url
  before_action :restrict_non_visible_user
  helper_method :current_user
  helper_method :unread_count
  helper_method :logged_in?
  helper_method :im
  helper_method :getting_started?

  private

  def find_user_by_username
    @user = User.visible.find_by(canonical_username: params[:username].downcase)
  end

  def back_or(path=nil)
    request.referer || path ||= root_path
  end

  def getting_started?
    params[:getting] == "started" ||
    request.path     =~ /start/ ||
    request.path     =~ /oops/
  end

  def logged_in?
    current_user
  end
  alias :im :logged_in?

  def logged_in_as_admin?
    logged_in? && current_user.admin?
  end

  def restrict_non_visible_user
    if current_user && !current_user.visible?
      redirect_to start_path
    end
  end

  def restrict_blocked_user(user, path=nil)
    path ||= root_path
    redirect_to path, notice: t("user.restrict_blocked_user_notice", username: user.username) if current_user.block_with_user?(user)
  end

  def require_login
    redirect_to root_path unless logged_in?
  end

  def require_admin
    redirect_to root_path unless logged_in_as_admin?
  end

  def current_user
    @current_user ||= User.find_by(auth_token: cookies.signed[:kypsy_auth_token]) unless cookies[:kypsy_auth_token].blank?
  end

  def unread_count
    messages = current_user.inbound_messages.unread.map(&:conversation_id).uniq.count
    messages.zero? ? nil : messages
  end

  def enforce_proper_url
    # if Rails.env.production? && request.url =~ /heroku/
    #   return redirect_to(t(:url))
    # end
  end

  def render_markdown(text)
    unless text.blank?
      Kramdown::Document.new(
        text,
        input: :kramdown,
        remove_block_html_tags: false,
        transliterated_header_ids: true
      ).to_html.html_safe
    end
  end
  helper_method :render_markdown
end
