module WelcomeHelper
  def welcome?
    @slug && @slug == "welcome"
  end
end
