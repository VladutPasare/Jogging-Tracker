module Api
  class UsersController < BaseController
    # Signup este public
    before_action :require_api_token, except: [:create]
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /api/users
    def index
      unless current_user.admin? || current_user.manager?
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      render json: User.all
    end

    # GET /api/users/:id
    def show
      unless current_user.admin? || current_user.manager? || current_user == @user
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      render json: @user
    end

    # POST /api/users (signup)
    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end

    # PATCH /api/users/:id
    def update
      unless current_user.admin? || current_user == @user
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/users/:id
    def destroy
      unless current_user.admin?
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      @user.destroy
      render json: { message: "User deleted" }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:name, :email, :password, :password_confirmation, :role)
    end
  end
end
