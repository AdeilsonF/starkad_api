module Api
  module V1
    class UsersController < ApiController
      before_action :auth_with_token!, only: [:update, :destroy]
      respond_to :json
      skip_before_action :auth_with_token!


      def show
        respond_with User.find(params[:id])
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: 201, location: [:api, user]
        else
          render json: {errors: user.errors}, status: 422
        end
      end

      def update
        user = current_user

        if user.update(user_params)
          render json: user, status: 200, location: [:api, user]
        else
          render json: {erros: user.errors}, status: 422
        end
      end

      def destroy
        current_user.destroy
        head 204
      end





      private

      def user_params
        if params[:user].present?
          params.require(:user).permit(:email, :password, :password_confirmation)
        else
          params.permit(:email, :password, :password_confirmation)
        end
      end

      def find_user
        User.find(params[:id])
      end
    end
  end
end
