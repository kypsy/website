module UsersHelper

  def labels_list(user, type, classes: nil, join: nil)
    output = []

    label_type = "desired_#{type}"

    unless user.send(label_type).blank?
      user.send(label_type).each do |dd|
        output << link_to(dd.name, search_path(search: [type, dd.name]), class: classes)
      end
    end

    output.join(join).html_safe
  end

  def social_sites
    {
      "snapchat"  => "https://snapchat.com/add/@@@",
      "twitter"   => "https://twitter.com/@@@",
      "instagram" => "https://instagram.com/@@@",
    }
  end

  def link_to_social(site, user)
    attr_name       = "#{site.gsub(/ /, '')}_username"
    social_username = user.send(attr_name)

    unless social_username.blank?
      url        = social_sites[site]
      link       = url.gsub(/@@@/, social_username)
      icon_name  = site
      icon_name += "-square" unless site == "instagram"

      link_to fa_icon(icon_name, class: "fa-lg"), link, rel: "me"
    end
  end

  def link_to_social_icons(user)
    social_sites.keys.map { |site| link_to_social(site, @user) }.compact.join(" ").html_safe
  end

end
