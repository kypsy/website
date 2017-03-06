module ApplicationHelper

  def admin?
    current_user && current_user.admin?
  end

  def strip_links(text)
    text.gsub(/<a /, "<span ").gsub(/<\/a>/, "<\/span>").html_safe
  end

  def user_profile?
    @slug == "person"
  end

  def cache_key_for_users
    count          = User.count
    max_updated_at = User.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "users/all-#{count}-#{max_updated_at}"
  end

  def user_inputed_text(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    renderer = KypsyHTML.new(filter_html: true, no_styles: true)
    markdown = Redcarpet::Markdown.new(renderer,
      no_intra_emphasis: true,
      no_links: true,
      underline: true,
      highlight: true
    )
    markdown.render(text).html_safe
  end

  def show_update_profile?
    profile_incomplete? &&
    !getting_started?   &&
    (@slug != "settings")
  end

  def profile_incomplete?
    current_user &&
    (current_user.desired_interests.blank? || current_user.desired_activities.blank?)
  end

  def link_to_avatar(user, avatar_size=nil)
    link_to image_tag(user.avatar(avatar_size), class: "u-photo d-flex mr-3", alt: user.username),
            person_path(user.username)
  end

  def link_to_username(user)
    link_to user.username, person_path(user.username), class: "p-name u-url"
  end

  def page_title
    @title || "#{t(:brand)} : #{t(:tagline)}"
  end

  def button_to_sign_in_with(provider)
    slug        = provider.to_s.downcase
    name        = slug.capitalize
    color_class = slug == "twitter" ? "info" : "primary"

    link_to "/auth/#{slug}", class: "#{slug}-sign-in-button btn btn-#{color_class}" do
      fa_icon(slug) + content_tag(:span, name, class: "hidden-sm-down ml-2")
    end
  end

  def mine?
    current_user && current_user == @user
  end

  def not_mine?
    current_user && current_user != @user
  end

  def google_map_url(user)
    url  = "http://maps.google.com/maps?q="

    pieces = []
    pieces << user.location if user.location

    url << u(pieces.join(", "))
    url
  end

  def api_url(path="")
    ENV["API_URL"] + path
  end

end
