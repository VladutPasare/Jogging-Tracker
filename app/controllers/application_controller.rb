class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_login
    redirect_to login_path, alert: "Trebuie să fii logat" unless logged_in?
  end

  def require_admin
    redirect_to root_path, alert: "Acces interzis (doar admin)" unless current_user&.admin?
  end

  def require_manager_or_admin
    unless current_user&.admin? || current_user&.manager?
      redirect_to root_path, alert: "Acces interzis"
    end
  end
end
