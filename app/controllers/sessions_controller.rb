class SessionsController < ApplicationController
  skip_before_action :restrict_non_visible_user
  after_action :create_credential, only: :create

  def create
    if current_user
      provider = Provider.from_auth(auth, ip_address: request.remote_ip)
      if provider
        current_user.merge! provider.user
        current_user.providers << provider
      else
        current_user.providers << Provider.create!(name: auth["provider"], uid: auth['uid'])
      end
    else
      provider = Provider.from_auth(auth, ip_address: request.remote_ip)
      user = provider ? provider.user : User.create_with_omniauth(auth)
      cookies.signed[:kypsy_auth_token] = {value: user.auth_token, expires: 2.weeks.from_now, secure: Rails.env.production?}
    end

    redirect_to people_path
  end

  def destroy
    cookies.delete :kypsy_auth_token
    redirect_to root_url, notice: "Signed out. Bye, for now!"
  end

  def failure
    redirect_to root_url, notice: params[:message]
  end

  private

  def auth
    request.env["omniauth.auth"]
  end

  def create_credential
    expires_at = auth.credentials.expires_at ? Time.at(auth.credentials.expires_at) : nil
    current_user.credentials.create(
      provider_name: auth.provider,
      token: auth.credentials.token,
      expires: auth.credentials.expires,
      expires_at: expires_at
    )
  end
end
