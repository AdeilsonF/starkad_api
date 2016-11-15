module Api
  module V1
    module Concerns
      module Authenticator
        # Devise methods overwrites
        def current_user
          @current_user ||=
            User.find_by(auth_token: request.headers['Authorization'])
        end

        def user_signed_in?
          current_user.present?
        end

        def auth_with_token!
          render json: { errors: "Not authenticated"},
            status: :unauthorized unless user_signed_in?
        end
      end
    end
  end
end
