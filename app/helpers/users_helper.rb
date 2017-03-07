module UsersHelper

  def show_section?(type)
    if type == :social
      ! social_sites.map{ |site, url| @user.send("#{site.downcase.gsub(/ /, "")}_username") }.join.blank?
    end
  end

  def labels_list(user, type, classes: nil)
    output = []

    label_type = "desired_#{type}"

    unless user.send(label_type).blank?
      user.send(label_type).each do |dd|
        output << link_to(dd.name, search_path(search: [type, dd.name]), class: classes)
      end
    end

    output.join.html_safe
  end

  def social_sites
    {
      "Twitter"   => "https://twitter.com/@@@",
      "Instagram" => "https://instagram.com/@@@",
      "Snapchat"  => "https://www.snapchat.com/add/@@@"
    }
  end
end
