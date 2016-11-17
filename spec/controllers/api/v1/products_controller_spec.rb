require 'rails_helper'

describe Api::V1::ProductsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:product) { FactoryGirl.create(:product) }

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create(:product)
      sign_in_user user
      get :show, params: { id: @product.id }
    end

    it "returns the information about a reporter on a hash" do
      expect(json_response[:title]).to eql @product.title
    end

    it { should respond_with 200}
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      sign_in_user user
      get :index
    end

    it "returns all records from the database" do
      expect(json_response).not_to be_empty
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      it "renders the json representation for the product record just created" do
        expect(json_response[:title]).to eql @product_attributes[:title]
      end


      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalide_product_attributes = { title: "Smart TV", price: "Twelve dollars"}
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @invalide_product_attributes }, session: {user_id: user.id}
      end

      it "renders an erros json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json erros on whye the user could not be created" do
        expect(json_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @product = FactoryGirl.create :product, user: user
      api_authorization_header user.auth_token
    end

    context "wheh is successfully updated" do
      before(:each) do
        patch :update, params: { user_id: user.id, id: @product.id, product: { title: "An expensive TV"}}
      end

      it "renders the json representation for the updated user" do
        expect(json_response[:title]).to eq "An expensive TV"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, params: { user_id: user.id, id: @product.id, 
                         product: { price: "An expensive TV" }}
      end

      it "renders an erros json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json erros on whye the user could not be updated" do
        expect(json_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end

  end

  describe "DELETE #destroy" do
    let(:product) { FactoryGirl.create(:product, user: user) }
    before(:each) do
      api_authorization_header user.auth_token
      delete :destroy, params: {user_id: user.id, id: product.id}
    end

    it { should respond_with 204 }
  end



end
