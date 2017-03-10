class AboutController < ApplicationController
  skip_before_action :restrict_non_visible_user, only: [:terms, :privacy]

  def terms
    @slug  = "about"
    @title = "Terms &amp; Conditions on #{t(:brand)}"
  end

  def privacy
    @slug = "privacy"
    @title = "Privacy Policy on #{t(:brand)}"
  end

  def us
    @slug  = "about"
    @title = "About Us, The Site and Code of Conduct"
  end

  def goodbye
    @slug  = "about"
    @title = "Goodbye, old friend! Come back anytime."
  end

  def tips
    @slug  = "tips"
    @title = "Pro Tips™ for using the site"
  end
  
  def well_known_apple_app_site_association
    render plain: ""
  end
end
