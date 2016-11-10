module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :auth_with_token!, only: [:create]
      def create

        user = User.find_by(email: session_params[:email])


        if user && user.valid_password?(session_params[:password])
          sign_in user, store: false
          user.generate_auth_token!
          user.save
          render json: user, status: 200, location: [:api, user]
        else
          render json: {errors: 'invalid email or password'}, status: 422
        end
      end

      def destroy
        current_user.generate_auth_token!
        current_user.save
        head 204
      end

      private

      def session_params
        if params[:session].present?
          params.require(:session).permit(:email, :password)
        else
          params.permit(:email, :password)
        end
      end
    end
  end
end
