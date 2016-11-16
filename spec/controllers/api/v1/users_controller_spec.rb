require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  before(:each) {request.headers['Accept'] = "application/vnd.starkadapi.v1, #{Mime::JSON}"}
  before(:each){request.headers['Content-Type'] = Mime::JSON.to_s}
  
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      expect(json_response[:email]).to eql @user.email
    end
    it {should respond_with 200}
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, {user: @user_attributes}, format: :json
      end

      it "renders the json representation for the user record just created" do
        expect(json_response[:email]).to eql(@user_attributes[:email])
      end

      it{should respond_with 201}


    end

    context "when is not created" do
      before(:each) do
        # warning i'm not including the email
        @invalid_user_attributes = {password: "12345",
                                    password_confirmation: "12345"}
        post :create, {user: @invalid_user_attributes}, format: :json
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it {should respond_with 422}
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      api_authorization_header @user.auth_token
    end

    context "when user is successfully updated" do
      before(:each) do
        patch :update,
          {id: @user.id, user: {email: "novoemail@mail.com"}},
          format: :json
      end

      it "renders the json representation for the updated user" do
        expect(json_response[:email]).to eq('novoemail@mail.com')
      end

      it {should respond_with 200}
    end

    context "when is not updated" do
      before(:each) do
        patch :update,
          {id: @user.id, user: {email: ""}},
          format: :json
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:erros)
      end

      it 'renders the json erros the user could not be updated' do
        expect(json_response[:erros][:email]).to include("can't be blank")
      end

      it {should respond_with 422}

    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      api_authorization_header @user.auth_token
      delete :destroy, {id: @user.id}, format: :json
    end
    it {should respond_with 204}
  end
end

