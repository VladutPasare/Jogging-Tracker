class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id

      if user.manager?
        redirect_to users_path, notice: "Autentificare reușită (Manager)"
      elsif user.admin?
        redirect_to jogging_entries_path, notice: "Autentificare reușită (Admin)"
      else
        redirect_to jogging_entries_path, notice: "Autentificare reușită"
      end
    else
      flash.now[:alert] = "Email sau parolă incorecte"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Te-ai delogat"
  end
end
