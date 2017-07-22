class AboutController < ApplicationController
  skip_before_action :restrict_non_visible_user, only: [:terms, :privacy]

  def terms
    @slug  = "about"
    @title = t("titles.terms", brand: t(:brand))
  end

  def privacy
    @slug = "privacy"
    @title = t("titles.privacy", brand: t(:brand))
  end

  def us
    @slug  = "about"
    @title = t("titles.about")
  end

  def goodbye
    @slug  = "about"
    @title = t("titles.goodbye")
  end

  def tips
    @slug  = "tips"
    @title = t("titles.tips")
  end

  def well_known_apple_app_site_association
    render plain: ""
  end
end
