module Api
  class BaseController < ActionController::API
    # Adăugăm manual modulul care lipseste în Rails 8 API
    include ActionController::RequestForgeryProtection

    # Dezactivăm CSRF pentru API
    skip_forgery_protection

    # Autentificare cu token
    def current_user
      token = request.headers["Authorization"]&.split(" ")&.last
      return nil if token.blank?

      @current_user ||= User.find_by(api_token: token)
    end

    def require_api_token
      unless current_user
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
