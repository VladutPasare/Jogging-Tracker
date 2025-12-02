module Api
  class SessionsController < BaseController
    # Doar logout necesită token. Login este public.
    before_action :require_api_token, only: [:destroy]

    # POST /api/login
    def create
      user = User.find_by(email: params[:email].to_s.downcase)

      if user && user.authenticate(params[:password])
        token = SecureRandom.hex(32)
        user.update(api_token: token)

        render json: {
          message: "Logged in",
          token: token,
          user: user
        }, status: :ok
      else
        render json: { error: "Invalid credentials" }, status: :unauthorized
      end
    end

    # DELETE /api/logout
    def destroy
      current_user.update(api_token: nil)
      render json: { message: "Logged out" }
    end
  end
end
