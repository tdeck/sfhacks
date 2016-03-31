class Admin::LoginController < ApplicationController
  def show
  end

  def submit
    password = params.require(:password)

    Rails.logger.info "App password: #{Rails.application.secrets.admin_password}"
    if password == Rails.application.secrets.admin_password
      session[:admin] = true
      redirect_to controller: :listings, action: :index
    else
      flash[:alert] = 'Incorrect password.'
      redirect_to action: :show
    end
  end
end
