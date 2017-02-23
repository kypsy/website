class Social::Facebook
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def photos
    begin
      client.get_connections("me", "photos")
    rescue => e
      Rollbar.error(e)
      []
    end
  end

  def info
    @info ||= client.get_object("me")
  end

  def birthday
    Date.strptime(info["birthday"], "%m/%d/%Y") if info["birthday"]
  end

  def valid?
    begin
      credential
      true
    rescue Social::SocialError
      false
    end
  end

  def client
    @client ||= Koala::Facebook::API.new(token)
  end

  def token
    credential.try(:token)
  end

  def credential
    @credential ||= user.credentials.where(provider_name: "facebook").order(created_at: :desc).first
    raise_error("No credentials found") if @credential.nil?
    @credential
  end

  def raise_error(msg)
    raise Social::SocialError, msg
  end
end
