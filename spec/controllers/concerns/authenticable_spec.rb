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
        api_authorization_header user.auth_token
        allow(authentication).to receive(:request).and_return(request)
      end

      it "returns the user from the authentication header" do
        expect(authentication.current_user.auth_token).to eq user.auth_token
      end
    end

    context "when wrong auth" do
      before do
        api_authorization_header 'wrong_token'
        allow(authentication).to receive(:request).and_return(request)
      end

      it "returns the user from the authorization header" do
        expect(authentication.current_user).to be_nil
      end
    end
  end

  describe "#auth_with_token" do
    before do
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:body).and_return({'errors' => 'Not authenticated'}.to_json)
      allow(response).to receive(:status).and_return(401)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "render a json message" do
      expect(json_response[:errors]).to eq 'Not authenticated'
    end

    it { expect(response.status).to eq 401}
  end

  describe "#user_signed_in?" do
    context 'when there is a user on a session' do
      before do
        allow(authentication).to receive(:current_user).and_return(user)
      end

      it { should be_user_signed_in}
    end


    context "when there is no user on 'session'" do
      before do
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in}
    end
  end


end
