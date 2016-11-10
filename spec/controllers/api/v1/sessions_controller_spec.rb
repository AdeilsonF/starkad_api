require 'rails_helper'

describe Api::V1::SessionsController do
  let(:user) { FactoryGirl.create(:user) } 

  describe "POST #create" do
    context "when the credentials are correct" do
      before(:each) do
        credentials = {email: user.email, password: "12345678"}
        post :create, params: { session: credentials }, format: :json
      end

      it "returns the user record corresponding to the given credentials" do
        user.reload
        expect(json_response[:auth_token]).to eq(user.auth_token)
      end

      it {should respond_with 200}
    end

    context "when credentials are incorrect" do
      before(:each) do
        credentials = { email: user.email, password: "invalidpassword" }
        post :create, params: {session: credentials}, format: :json
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "invalid email or password"
      end

      it {should respond_with 422}
    end

  end

  describe "DELETE #destroy" do
    before(:each) do
      sign_in_user user
      delete :destroy, params: { id: user.id }
    end

    it {should respond_with 204}
  end
end
