module ApplicationHelper

  def admin?
    current_user && current_user.admin?
  end

  def opening_body_tag
    if user_profile?
      "<body class='h-card vcard'>".html_safe
    else
      "<body>".html_safe
    end
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
    !(controller_name == "users" && action_name == "edit")
  end

  def profile_incomplete?
    current_user &&
    current_user.me_gender  == "person" &&
    current_user.you_gender == "person" &&
    current_user.label_id.blank? &&
    current_user.diet_id.blank?
  end

  def birthday_select_tag(f)
    f.date_select :birthday,
                  {
                    order:         [:month, :day, :year],
                    start_year:    12.years.ago.year,
                    end_year:      60.years.ago.year,
                    include_blank: true
                  },
                  { class:         "form-control" }
  end

  def link_to_avatar(user, avatar_size=nil)
    link_to image_tag(user.avatar(avatar_size), class: "u-photo img media-object", alt: user.username),
            person_path(user.username),
            class: "pull-left u-url"
  end

  def link_to_username(user)
    link_to user.username, person_path(user.username), class: "p-name u-url"
  end

  def page_title
    @title || "#{t(:brand)} : #{t(:tagline)}"
  end

  def button_to_sign_in_with(provider)
    if provider.to_s.downcase    == "twitter"
      link_to "#{fa_icon :twitter}  Twitter".html_safe,  "/auth/twitter",  class: "twitter-sign-in-button btn btn-info"
    elsif provider.to_s.downcase == "facebook"
      link_to "#{fa_icon :facebook} Facebook".html_safe, "/auth/facebook", class: "facebook-sign-in-button btn btn-primary"
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
    pieces << user.city         if user.city
    pieces << user.state        if user.state
    pieces << user.country.name if user.country

    url << u(pieces.join(", "))
    url
  end

  def drug_friendly_all_nevers?(user)
    user.drug_use.map{ |d| d.last }.uniq == ["never"]
  end

  def api_url(path="")
    ENV["API_URL"] + path
  end

end
