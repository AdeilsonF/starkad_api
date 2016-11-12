require 'rails_helper'

class Authentication < ActionController::Base
  include Api::V1::Concerns::Authenticator
end

describe Api::V1::Concerns::Authenticator do
  let(:user) { FactoryGirl.create(:user) }
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "current_user" do
    context "when correct auth" do
      before do
        request.headers['Authorization'] = user.auth_token
        allow(authentication).to receive(:request).and_return(request)
      end

      it "returns the user from the authentication header" do
        expect(authentication.current_user.auth_token).to eq user.auth_token
      end
    end

    context "when wrong auth" do
      before do
        request.headers['Authorization'] = 'wrong_token'
        allow(authentication).to receive(:request).and_return(request)
      end

      it "returns the user from the authorization header" do
        expect(authentication.current_user).to be_nil
      end
    end
  end
end
